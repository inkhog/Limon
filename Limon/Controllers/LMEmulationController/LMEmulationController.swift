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
    
    var roomState: RoomState = .RSUninitialized
    
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
                self.virtualControllerView.hide()
            })
        }
        
        thread = .init(block: {
            self.citra().run()
        })
        thread.qualityOfService = .userInteractive
        thread.threadPriority = 1.0
    }
    
    override var prefersStatusBarHidden: Bool {
        true
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
            thread.start()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        citra().setOrientation(UIDevice.current.orientation, with: screenView.screen.layer as! CAMetalLayer)
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
            case .RSIdle, .RSUninitialized:
                configuration.baseBackgroundColor = .systemGray
            case .RSJoined:
                configuration.baseBackgroundColor = .systemGreen
            case .RSJoining:
                configuration.baseBackgroundColor = .systemOrange
            case .RSModerator:
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
        NotificationCenter.default.addObserver(forName: NSNotification.Name.GCControllerDidConnect, object: nil, queue: .main, using: controllerDidConnect(_:))
        NotificationCenter.default.addObserver(forName: NSNotification.Name.GCControllerDidDisconnect, object: nil, queue: .main, using: controllerDidDisconnect(_:))
        
        NotificationCenter.default.addObserver(forName: .init("onRoomStateChanged"), object: nil, queue: .main, using: onRoomStateChanged(_:))
    }
    // MARK: END REGISTER NOTIFICATIONS
    
    
    
    // MARK: START CONTROLLER NOTIFICATIONS
    fileprivate func controllerDidConnect(_ notification: Notification) {
        guard let controller = GCController.current, let extendedGamepad = controller.extendedGamepad else {
            return
        }
        
        extendedGamepad.buttonA.pressedChangedHandler = EmulationInput.buttonA.pressChangedHandler
        extendedGamepad.buttonB.pressedChangedHandler = EmulationInput.buttonB.pressChangedHandler
        extendedGamepad.buttonX.pressedChangedHandler = EmulationInput.buttonX.pressChangedHandler
        extendedGamepad.buttonY.pressedChangedHandler = EmulationInput.buttonY.pressChangedHandler
        
        extendedGamepad.dpad.left.pressedChangedHandler = EmulationInput.dpadLeft.pressChangedHandler
        extendedGamepad.dpad.down.pressedChangedHandler = EmulationInput.dpadDown.pressChangedHandler
        extendedGamepad.dpad.up.pressedChangedHandler = EmulationInput.dpadUp.pressChangedHandler
        extendedGamepad.dpad.right.pressedChangedHandler = EmulationInput.dpadRight.pressChangedHandler
        
        extendedGamepad.buttonOptions?.pressedChangedHandler = EmulationInput.buttonSelect.pressChangedHandler
        extendedGamepad.buttonMenu.pressedChangedHandler = EmulationInput.buttonStart.pressChangedHandler
        
        extendedGamepad.leftShoulder.valueChangedHandler = EmulationInput.buttonL.pressChangedHandler
        extendedGamepad.leftTrigger.valueChangedHandler = EmulationInput.buttonZL.pressChangedHandler
        extendedGamepad.rightShoulder.valueChangedHandler = EmulationInput.buttonR.pressChangedHandler
        extendedGamepad.rightTrigger.valueChangedHandler = EmulationInput.buttonZR.pressChangedHandler
        
        extendedGamepad.leftThumbstick.valueChangedHandler = EmulationInput.leftThumbstick.valueChangedHandler
        extendedGamepad.rightThumbstick.valueChangedHandler = EmulationInput.rightThumstick.valueChangedHandler
        
        self.virtualControllerView.hide()
    }
    
    fileprivate func controllerDidDisconnect(_ notification: Notification) {
        self.virtualControllerView.show()
    }
    // MARK: END CONTROLLER NOTIFICATIONS
    
    
    
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
    
    
    
    // MARK: START RELOAD IN GAME SETTINGS MENU
    fileprivate func reloadInGameSettingsMenu() {
        Task {
            self.inGameSettingsButton.menu = self.inGameSettingsMenu()
        }
    }
    // MARK: END RELOAD IN GAME SETTINGS MENU
    
    
    
    // MARK: START SCREEN LAYOUTS MENU
    fileprivate func screenLayoutsMenu() -> UIMenu {
        let screenLayouts = [
            (title: "Default", option: 0), (title: "Single Screen", option: 1), (title: "Large Screen", option: 2), (title: "Side Screen", option: 3),
            (title: "Hybrid Screen", option: 5), (title: "Mobile Portrait", option: 6), (title: "Mobile Landscape", option: 7)
        ]
        
        return .init(options: .displayInline, preferredElementSize: .small, children: [
            UIMenu(title: "Screen Layouts", image: .init(systemName: "rectangle.3.group.fill"), children: screenLayouts.reduce(into: [UIAction]()) { partialResult, layout in
                partialResult.append(.init(title: layout.title, state: self.citra()._layoutOption == layout.option ? .on : .off, handler: { _ in
                    self.citra().setLayoutOption(UInt(layout.option), with: self.screenView.screen.layer as! CAMetalLayer)
                    self.reloadInGameSettingsMenu()
                }))
            }),
            UIAction(title: "Swap Screens", image: .init(systemName: "rectangle.2.swap"), handler: { _ in
                self.citra().swapScreens(self.screenView.screen.layer as! CAMetalLayer)
            })
        ])
    }
    // MARK: END SCREEN LAYOUTS MENU
    
    
    
    // MARK: START EMULATION STATES MENU
    fileprivate func emulationStatesMenu() -> UIMenu {
        let emulationStates: [(title: String, systemName: String, action: UIActionHandler, attributes: UIMenuElement.Attributes)] = [
            (title: "Pause", systemName: "pause.fill", action: { action in
                self.citra().pause()
                self.reloadInGameSettingsMenu()
            }, attributes: self.citra().isPaused() ? [.disabled] : []),
            (title: "Resume", systemName: "play.fill", action: { action in
                self.citra().resume()
                self.reloadInGameSettingsMenu()
            }, attributes: self.citra().isPaused() ? [] : [.disabled]),
            (title: "Stop", systemName: "stop.fill", action: { action in
                self.citra().stop()
                self.reloadInGameSettingsMenu()
            }, attributes: .disabled)
        ]
        
        return .init(options: .displayInline, preferredElementSize: .small, children: emulationStates.reduce(into: [UIAction](), { partialResult, state in
            partialResult.append(.init(title: state.title, image: .init(systemName: state.systemName), attributes: state.attributes, handler: state.action))
        }))
    }
    // MARK: END EMULATION STATES MENU
    
    
    
    // MARK: START APPEARANCE MENU
    fileprivate func appearanceMenu() -> UIMenu {
        .init(options: .displayInline, children: [
            UIMenu(options: .displayInline, preferredElementSize: .small, children: [
                UIAction(title: "Filled", image: .init(systemName: "drop.fill"), attributes: self.virtualControllerView.appearance == .filled ? [.disabled] : [], handler: { _ in
                    self.virtualControllerView.filled()
                    self.reloadInGameSettingsMenu()
                }),
                UIAction(title: "Tinted", image: .init(systemName: "drop.halffull"), attributes: self.virtualControllerView.appearance == .filled ? [] : [.disabled], handler: { _ in
                    self.virtualControllerView.tinted()
                    self.reloadInGameSettingsMenu()
                })
            ])
        ])
    }
    // MARK: END APPEARANCE MENU
    
    
    
    // MARK: START MUTLIPLAYER MENU
    fileprivate func multiplayerMenu() -> UIMenu {
        .init(title: "Multiplayer", image: UIImage(systemName: "person.2.fill"), children: [
            UIAction(title: "Direct Connect", image: .init(systemName: "person.line.dotted.person.fill"), handler: { _ in
                self.citra().pause()
                self.reloadInGameSettingsMenu()
                
                let directConnectController = LMDirectConnectController(.init(systemName: "person.line.dotted.person.fill"), "Direct Connect",
                    "Connect directly to a multiplayer room by entering your nickname along with the room's IP address, port if non-default and password if password protected")
                directConnectController.modalPresentationStyle = .fullScreen
                self.present(directConnectController, animated: true)
            })
        ])
    }
    // MARK: END MULTIPLAYER MENU
    
    
    
    // MARK: START IN GAME SETTINGS MENU
    fileprivate func inGameSettingsMenu() -> UIMenu {
        .init(children: [
            appearanceMenu(),
            multiplayerMenu(),
            screenLayoutsMenu(),
            emulationStatesMenu()
        ])
    }
    // MARK: END IN GAME SETTINGS MENU
}



// MARK: START ABXY BUTTON DELEGATE
extension LMEmulationController : ABXYButtonDelegate {
    func touchDown(_ buttonType: ABXYButton.ButtonType) {
        switch buttonType {
        case .a:
            EmulationInput.buttonA.pressChangedHandler(nil, value: 1.0, pressed: true)
        case .b:
            EmulationInput.buttonB.pressChangedHandler(nil, value: 1.0, pressed: true)
        case .x:
            EmulationInput.buttonX.pressChangedHandler(nil, value: 1.0, pressed: true)
        case .y:
            EmulationInput.buttonY.pressChangedHandler(nil, value: 1.0, pressed: true)
        }
    }
    
    func touchUpInside(_ buttonType: ABXYButton.ButtonType) {
        switch buttonType {
        case .a:
            EmulationInput.buttonA.pressChangedHandler(nil, value: 0.0, pressed: false)
        case .b:
            EmulationInput.buttonB.pressChangedHandler(nil, value: 0.0, pressed: false)
        case .x:
            EmulationInput.buttonX.pressChangedHandler(nil, value: 0.0, pressed: false)
        case .y:
            EmulationInput.buttonY.pressChangedHandler(nil, value: 0.0, pressed: false)
        }
    }
}
// MARK: END ABXY BUTTON DELEGATE



// MARK: START LDUR BUTTON DELEGATE
extension LMEmulationController : LDURButtonDelegate {
    func touchDown(_ buttonType: LDURButton.ButtonType) {
        switch buttonType {
        case .left:
            EmulationInput.dpadLeft.pressChangedHandler(nil, value: 1.0, pressed: true)
        case .down:
            EmulationInput.dpadDown.pressChangedHandler(nil, value: 1.0, pressed: true)
        case .up:
            EmulationInput.dpadUp.pressChangedHandler(nil, value: 1.0, pressed: true)
        case .right:
            EmulationInput.dpadRight.pressChangedHandler(nil, value: 1.0, pressed: true)
        }
    }
    
    func touchUpInside(_ buttonType: LDURButton.ButtonType) {
        switch buttonType {
        case .left:
            EmulationInput.dpadLeft.pressChangedHandler(nil, value: 0.0, pressed: false)
        case .down:
            EmulationInput.dpadDown.pressChangedHandler(nil, value: 0.0, pressed: false)
        case .up:
            EmulationInput.dpadUp.pressChangedHandler(nil, value: 0.0, pressed: false)
        case .right:
            EmulationInput.dpadRight.pressChangedHandler(nil, value: 0.0, pressed: false)
        }
    }
}
// MARK: END LDUR BUTTON DELEGATE



// MARK: START SELECT START BUTTON DELEGATE
extension LMEmulationController : SelectStartButtonDelegate {
    func touchDown(_ buttonType: SelectStartButton.ButtonType) {
        switch buttonType {
        case .select:
            EmulationInput.buttonSelect.pressChangedHandler(nil, value: 1.0, pressed: true)
        case .start:
            EmulationInput.buttonStart.pressChangedHandler(nil, value: 1.0, pressed: true)
        }
    }
    
    func touchUpInside(_ buttonType: SelectStartButton.ButtonType) {
        switch buttonType {
        case .select:
            EmulationInput.buttonSelect.pressChangedHandler(nil, value: 0.0, pressed: false)
        case .start:
            EmulationInput.buttonStart.pressChangedHandler(nil, value: 0.0, pressed: false)
        }
    }
}
// MARK: END SELECT START BUTTON DELEGATE



// MARK: START BUMPER TRIGGER BUTTON DELEGATE
extension LMEmulationController : BumperTriggerButtonDelegate {
    func touchDown(_ buttonType: BumperTriggerButton.ButtonType) {
        switch buttonType {
        case .l:
            EmulationInput.buttonL.pressChangedHandler(nil, value: 1.0, pressed: true)
        case .zl:
            EmulationInput.buttonZL.pressChangedHandler(nil, value: 1.0, pressed: true)
        case .r:
            EmulationInput.buttonR.pressChangedHandler(nil, value: 1.0, pressed: true)
        case .zr:
            EmulationInput.buttonZR.pressChangedHandler(nil, value: 1.0, pressed: true)
        }
    }
    
    func touchUpInside(_ buttonType: BumperTriggerButton.ButtonType) {
        switch buttonType {
        case .l:
            EmulationInput.buttonL.pressChangedHandler(nil, value: 0.0, pressed: false)
        case .zl:
            EmulationInput.buttonZL.pressChangedHandler(nil, value: 0.0, pressed: false)
        case .r:
            EmulationInput.buttonR.pressChangedHandler(nil, value: 0.0, pressed: false)
        case .zr:
            EmulationInput.buttonZR.pressChangedHandler(nil, value: 0.0, pressed: false)
        }
    }
}
// MARK: END BUMPER TRIGGER BUTTON DELEGATE



// MARK: START THUMBSTICK VIEW DELEGATE
extension LMEmulationController : ThumbstickViewDelegate {
    func touchesBegan(_ position: ThumbstickTouchPosition, for thumbstick: ThumbstickView.ThumbstickType) {
        
    }
    
    func touchesEnded() {
        EmulationInput.leftThumbstick.valueChangedHandler(nil, x: 0, y: 0)
        EmulationInput.rightThumstick.valueChangedHandler(nil, x: 0, y: 0)
    }
    
    func touchesMoved(_ position: ThumbstickTouchPosition, for thumbstick: ThumbstickView.ThumbstickType) {
        switch thumbstick {
        case .left:
            EmulationInput.leftThumbstick.valueChangedHandler(nil, x: position.x, y: position.y)
        case .right:
            EmulationInput.rightThumstick.valueChangedHandler(nil, x: position.x, y: position.y)
        }
    }
}
// MARK: END THUMBSTICK VIEW DELEGATE
