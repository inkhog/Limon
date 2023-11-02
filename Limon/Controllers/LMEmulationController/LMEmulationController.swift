//
//  LMEmulationController.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

import Foundation
import MetalKit
import UIKit

class LMEmulationController : UIViewController {
    var thread: Thread!
    
    var inGameSettingsButton: UIButton!
    var virtualControllerView: LMVirtualControllerView!
    var screenView = LMScreenView(frame: UIScreen.main.bounds)
    
    var roomState: RoomState = .uninitialized
    
    var game: AnyHashable
    init(game: AnyHashable) {
        self.game = game
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = screenView
        
        switch game {
        case let imported as LMImportedGame:
            citra().insert(imported.path)
        case let installed as LMInstalledGame:
            citra().insert(installed.path)
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        useCustomBackgroundColor(.black)
        addSubviews()
        addSubviewConstraints()
        registerControllerNotifications()
        if GCController.controllers().count > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.virtualControllerView.physicalControllerDidConnect()
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        
        if touch.view == screenView.screen {
            citra().touchesBegan(point: touch.location(in: screenView.screen))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        citra().touchesEnded()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        
        if touch.view == screenView.screen {
            citra().touchesMoved(point: touch.location(in: screenView.screen))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !citra().isRunning() {
            citra().setMetalLayer(screenView.screen.layer as! CAMetalLayer)
            Thread.detachNewThread {
                self.citra().run()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .init("onRoomStateChanged"), object: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.citra().setOrientation(UIDevice.current.orientation, with: self.screenView.screen.layer as! CAMetalLayer)
    }
    
    // MARK: START ADD SUBVIEWS
    fileprivate func addSubviews() {
        virtualControllerView = LMVirtualControllerView()
        virtualControllerView.translatesAutoresizingMaskIntoConstraints = false
        virtualControllerView.abxyButtonDelegate = self
        virtualControllerView.ldurButtonDelegate = self
        virtualControllerView.selectStartButtonDelegate = self
        virtualControllerView.bumperTriggerButtonDelegate = self
        virtualControllerView.leftThumbstickViewDelegate = self
        virtualControllerView.rightThumbstickViewDelegate = self
        virtualControllerView.addAllButtons()
        view.addSubview(virtualControllerView)
        
        
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .small
        configuration.cornerStyle = .capsule
        configuration.image = .init(systemName: "gearshape.2.fill")?.applyingSymbolConfiguration(.init(scale: .medium))
        
        inGameSettingsButton = .init(configuration: configuration)
        inGameSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        inGameSettingsButton.configurationUpdateHandler = { button in
            guard var configuration = button.configuration else {
                return
            }
            
            switch self.roomState {
            case .idle, .uninitialized:
                configuration.baseBackgroundColor = .systemGray
            case .joined:
                configuration.baseBackgroundColor = .systemGreen
            case .joining:
                configuration.baseBackgroundColor = .systemOrange
            case .moderator:
                configuration.baseBackgroundColor = .systemYellow
            default:
                break
            }
            button.configuration = configuration
        }
        inGameSettingsButton.menu = inGameSettingsMenu()
        inGameSettingsButton.showsMenuAsPrimaryAction = true
        view.addSubview(inGameSettingsButton)
    }
    // MARK: END ADD SUBVIEWS
    
    
    
    // MARK: START ADD SUBVIEW CONSTRAINTS
    fileprivate func addSubviewConstraints() {
        view.addConstraints([
            virtualControllerView.topAnchor.constraint(equalTo: view.topAnchor),
            virtualControllerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            virtualControllerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            virtualControllerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            inGameSettingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            inGameSettingsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            inGameSettingsButton.widthAnchor.constraint(equalToConstant: 48),
            inGameSettingsButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    // MARK: END ADD SUBVIEW CONSTRAINTS
    
    
    
    // MARK: START REGISTER NOTIFICATIONS
    fileprivate func registerControllerNotifications() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.GCControllerDidConnect, object: nil, queue: .main, using: physicalControllerDidConnect(_:))
        NotificationCenter.default.addObserver(forName: NSNotification.Name.GCControllerDidDisconnect, object: nil, queue: .main, using: physicalControllerDidDisconnect(_:))
        
        NotificationCenter.default.addObserver(forName: .init("onRoomStateChanged"), object: nil, queue: .main, using: onRoomStateChanged(_:))
    }
    // MARK: END REGISTER NOTIFICATIONS
    
    
    
    // MARK: START MULTIPLAYER NOTIFICATIONS
    fileprivate func onRoomStateChanged(_ notification: Notification) {
        guard let state = notification.object as? RoomState else {
            return
        }
        
        roomState = state
        Task {
            inGameSettingsButton.menu = inGameSettingsMenu()
            inGameSettingsButton.setNeedsUpdateConfiguration()
        }
    }
    // MARK: END MULTIPLAYER NOTIFICATIONS
}
