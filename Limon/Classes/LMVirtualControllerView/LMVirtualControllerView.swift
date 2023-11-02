//
//  LMVirtualControllerView.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

import Foundation
import UIKit

class LMVirtualControllerView : UIView {
    var abxyButtonDelegate: ABXYButtonDelegate?
    var ldurButtonDelegate: LDURButtonDelegate?
    var selectStartButtonDelegate: SelectStartButtonDelegate?
    var bumperTriggerButtonDelegate: BumperTriggerButtonDelegate?
    var leftThumbstickViewDelegate, rightThumbstickViewDelegate: ThumbstickViewDelegate?
    
    var selectButton, startButton: SelectStartButton!
    var lButton, zlButton, rButton, zrButton: BumperTriggerButton!
    
    var leftThumbstickView, rightThumbstickView: ThumbstickView!
    
    var leftPadView: LeftPadView!
    var rightPadView: RightPadView!
    
    var portraitSelectConstraint, portraitStartConstraint: NSLayoutConstraint!
    var landscapeSelectConstraint, landscapeStartConstraint: NSLayoutConstraint!
    
    enum State {
        case activated, deactivated
    }
    
    enum Appearance {
        case filled, tinted
    }
    
    var appearance: Appearance = .filled
    var bumpersTriggersHidden: Bool = false
    var state: State = .activated
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leftPadView = .init()
        leftPadView.delegate = self
        addSubview(leftPadView)
        
        rightPadView = .init()
        rightPadView.delegate = self
        addSubview(rightPadView)
        
        addConstraints([
            leftPadView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            leftPadView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            rightPadView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            rightPadView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
            let orientation = UIDevice.current.orientation
            if orientation == .portrait {
                self.removeConstraints([self.landscapeSelectConstraint, self.landscapeStartConstraint])
                self.addConstraints([self.portraitSelectConstraint, self.portraitStartConstraint])
            } else if orientation == .landscapeLeft || orientation == .landscapeRight {
                self.removeConstraints([self.portraitSelectConstraint, self.portraitStartConstraint])
                self.addConstraints([self.landscapeSelectConstraint, self.landscapeStartConstraint])
            }
            
            self.setNeedsUpdateConstraints()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        state == .activated ? super.hitTest(point, with: event) == self ? nil : super.hitTest(point, with: event) : nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard state == .activated, let selectStartButtonDelegate, let bumperTriggerButtonDelegate, let touch = touches.first else {
            return
        }
        
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        
        switch touch.view {
        case selectButton, startButton:
            selectStartButtonDelegate.touch((touch.view as! SelectStartButton).buttonType, .down)
        case lButton, zlButton, rButton, zrButton:
            bumperTriggerButtonDelegate.touch((touch.view as! BumperTriggerButton).buttonType, .down)
        default:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard state == .activated, let selectStartButtonDelegate, let bumperTriggerButtonDelegate, let touch = touches.first else {
            return
        }
        
        switch touch.view {
        case selectButton, startButton:
            selectStartButtonDelegate.touch((touch.view as! SelectStartButton).buttonType, .up)
        case lButton, zlButton, rButton, zrButton:
            bumperTriggerButtonDelegate.touch((touch.view as! BumperTriggerButton).buttonType, .up)
        default:
            break
        }
    }
    
    
    @objc func hideBumpersTriggers() {
        bumpersTriggersHidden = true
        if #available(iOS 17, *) {
            lButton.letterImageView.addSymbolEffect(.disappear)
            zlButton.letterImageView.addSymbolEffect(.disappear)
            rButton.letterImageView.addSymbolEffect(.disappear)
            zrButton.letterImageView.addSymbolEffect(.disappear)
        } else {
            UIView.animate(withDuration: 0.1) {
                self.lButton.alpha = 0
                self.zlButton.alpha = 0
                self.rButton.alpha = 0
                self.zrButton.alpha = 0
            }
        }
        
        lButton.isUserInteractionEnabled = false
        zlButton.isUserInteractionEnabled = false
        rButton.isUserInteractionEnabled = false
        zrButton.isUserInteractionEnabled = false
    }
    
    @objc func showBumpersTriggers() {
        bumpersTriggersHidden = false
        if #available(iOS 17, *) {
            lButton.letterImageView.addSymbolEffect(.appear)
            zlButton.letterImageView.addSymbolEffect(.appear)
            rButton.letterImageView.addSymbolEffect(.appear)
            zrButton.letterImageView.addSymbolEffect(.appear)
        } else {
            UIView.animate(withDuration: 0.1) {
                self.lButton.alpha = 1
                self.zlButton.alpha = 1
                self.rButton.alpha = 1
                self.zrButton.alpha = 1
            }
        }
        
        lButton.isUserInteractionEnabled = true
        zlButton.isUserInteractionEnabled = true
        rButton.isUserInteractionEnabled = true
        zrButton.isUserInteractionEnabled = true
    }
    
    
    func addSelectButton() {
        selectButton = .init(.select)
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectButton)
        
        portraitSelectConstraint = selectButton.trailingAnchor.constraint(equalTo: leftPadView.trailingAnchor, constant: 10)
        landscapeSelectConstraint = selectButton.leadingAnchor.constraint(equalTo: leftPadView.trailingAnchor)
        
        addConstraints([
            selectButton.widthAnchor.constraint(equalToConstant: 40),
            selectButton.heightAnchor.constraint(equalToConstant: 40),
            
            selectButton.bottomAnchor.constraint(equalTo: leftPadView.bottomAnchor),
            portraitSelectConstraint
        ])
    }
    
    func addStartButton() {
        startButton = .init(.start)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(startButton)
        
        portraitStartConstraint = startButton.leadingAnchor.constraint(equalTo: rightPadView.leadingAnchor, constant: -10)
        landscapeStartConstraint = startButton.trailingAnchor.constraint(equalTo: rightPadView.leadingAnchor)
        
        addConstraints([
            startButton.widthAnchor.constraint(equalToConstant: 40),
            startButton.heightAnchor.constraint(equalToConstant: 40),
            
            portraitStartConstraint,
            startButton.bottomAnchor.constraint(equalTo: rightPadView.bottomAnchor)
        ])
    }
    
    
    func addLButton() {
        lButton = .init(.l)
        lButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lButton)
        
        addConstraints([
            lButton.widthAnchor.constraint(equalToConstant: 56),
            lButton.heightAnchor.constraint(equalToConstant: 48),
            lButton.bottomAnchor.constraint(equalTo: leftPadView.topAnchor, constant: -20),
            lButton.leadingAnchor.constraint(equalTo: leftPadView.leadingAnchor)
        ])
    }
    
    func addZLButton() {
        zlButton = .init(.zl)
        zlButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(zlButton)
        
        addConstraints([
            zlButton.widthAnchor.constraint(equalToConstant: 56),
            zlButton.heightAnchor.constraint(equalToConstant: 48),
            zlButton.topAnchor.constraint(equalTo: lButton.safeAreaLayoutGuide.topAnchor),
            zlButton.leadingAnchor.constraint(equalTo: lButton.safeAreaLayoutGuide.trailingAnchor, constant: 20)
        ])
    }
    
    func addRButton() {
        rButton = .init(.r)
        rButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rButton)
        
        addConstraints([
            rButton.widthAnchor.constraint(equalToConstant: 56),
            rButton.heightAnchor.constraint(equalToConstant: 48),
            rButton.bottomAnchor.constraint(equalTo: rightPadView.topAnchor, constant: -20),
            rButton.trailingAnchor.constraint(equalTo: rightPadView.trailingAnchor)
        ])
    }
    
    func addZRButton() {
        zrButton = .init(.zr)
        zrButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(zrButton)
        
        addConstraints([
            zrButton.widthAnchor.constraint(equalToConstant: 56),
            zrButton.heightAnchor.constraint(equalToConstant: 48),
            zrButton.topAnchor.constraint(equalTo: rButton.safeAreaLayoutGuide.topAnchor),
            zrButton.trailingAnchor.constraint(equalTo: rButton.safeAreaLayoutGuide.leadingAnchor, constant: -20)
        ])
    }
    
    
    func addLeftThumbstickView() {
        leftThumbstickView = .init(.left)
        leftThumbstickView.translatesAutoresizingMaskIntoConstraints = false
        leftThumbstickView.delegate = leftThumbstickViewDelegate
        addSubview(leftThumbstickView)
        insertSubview(leftThumbstickView, belowSubview: leftPadView)
        
        addConstraints([
            leftThumbstickView.topAnchor.constraint(equalTo: leftPadView.topAnchor),
            leftThumbstickView.leadingAnchor.constraint(equalTo: leftPadView.leadingAnchor),
            leftThumbstickView.bottomAnchor.constraint(equalTo: leftPadView.bottomAnchor),
            leftThumbstickView.trailingAnchor.constraint(equalTo: leftPadView.trailingAnchor)
        ])
    }
    
    func addRightThumbstickView() {
        rightThumbstickView = .init(.right)
        rightThumbstickView.translatesAutoresizingMaskIntoConstraints = false
        rightThumbstickView.delegate = rightThumbstickViewDelegate
        addSubview(rightThumbstickView)
        insertSubview(rightThumbstickView, belowSubview: rightPadView)
        
        addConstraints([
            rightThumbstickView.topAnchor.constraint(equalTo: rightPadView.topAnchor),
            rightThumbstickView.leadingAnchor.constraint(equalTo: rightPadView.leadingAnchor),
            rightThumbstickView.bottomAnchor.constraint(equalTo: rightPadView.bottomAnchor),
            rightThumbstickView.trailingAnchor.constraint(equalTo: rightPadView.trailingAnchor)
        ])
    }
    
    
    func hideLeftPadView() {
        leftPadView.hide()
        UIView.animate(withDuration: 0.1) {
            self.leftThumbstickView.backgroundColor = .systemGray.withAlphaComponent(0.66)
        }
    }
    
    func showLeftPadView() {
        leftPadView.show()
        UIView.animate(withDuration: 0.1) {
            self.leftThumbstickView.backgroundColor = nil
        }
    }
    
    func hideRightPadView() {
        rightPadView.hide()
        UIView.animate(withDuration: 0.1) {
            self.rightThumbstickView.backgroundColor = .systemGray.withAlphaComponent(0.66)
        }
    }
    
    func showRightPadView() {
        rightPadView.show()
        UIView.animate(withDuration: 0.1) {
            self.rightThumbstickView.backgroundColor = nil
        }
    }
    
    
    func filled() {
        appearance = .filled
        
        leftPadView.filled()
        rightPadView.filled()
        
        selectButton.filled()
        startButton.filled()
        
        lButton.filled()
        zlButton.filled()
        rButton.filled()
        zrButton.filled()
    }
    
    func tinted() {
        appearance = .tinted
        
        leftPadView.tinted()
        rightPadView.tinted()
        
        selectButton.tinted()
        startButton.tinted()
        
        lButton.tinted()
        zlButton.tinted()
        rButton.tinted()
        zrButton.tinted()
    }
    
    func addAllButtons() {
        addSelectButton()
        addStartButton()
        
        addLButton()
        addZLButton()
        addRButton()
        addZRButton()
        
        addLeftThumbstickView()
        addRightThumbstickView()
    }
    
    
    func physicalControllerDidConnect() {
        state = .deactivated
        
        leftPadView.hide()
        rightPadView.hide()
        
        if #available(iOS 17, *) {
            selectButton.letterImageView.addSymbolEffect(.disappear)
            startButton.letterImageView.addSymbolEffect(.disappear)
            
            lButton.letterImageView.addSymbolEffect(.disappear)
            zlButton.letterImageView.addSymbolEffect(.disappear)
            rButton.letterImageView.addSymbolEffect(.disappear)
            zrButton.letterImageView.addSymbolEffect(.disappear)
        } else {
            UIView.animate(withDuration: 0.1) {
                self.selectButton.alpha = 0
                self.startButton.alpha = 0
                
                self.lButton.alpha = 0
                self.zlButton.alpha = 0
                self.rButton.alpha = 0
                self.zrButton.alpha = 0
            }
        }
    }
    
    func physicalControllerDidDisconnect() {
        state = .activated
        
        leftPadView.show()
        rightPadView.show()
        
        if #available(iOS 17, *) {
            selectButton.letterImageView.addSymbolEffect(.appear)
            startButton.letterImageView.addSymbolEffect(.appear)
            
            lButton.letterImageView.addSymbolEffect(.appear)
            zlButton.letterImageView.addSymbolEffect(.appear)
            rButton.letterImageView.addSymbolEffect(.appear)
            zrButton.letterImageView.addSymbolEffect(.appear)
        } else {
            UIView.animate(withDuration: 0.1) {
                self.selectButton.alpha = 1
                self.startButton.alpha = 1
                
                self.lButton.alpha = 1
                self.zlButton.alpha = 1
                self.rButton.alpha = 1
                self.zrButton.alpha = 1
            }
        }
    }
}


extension LMVirtualControllerView : LDURButtonDelegate {
    func touch(_ buttonType: LDURButton.ButtonType, _ touchType: TouchType) {
        guard let ldurButtonDelegate else {
            return
        }
        
        ldurButtonDelegate.touch(buttonType, touchType)
    }
}

extension LMVirtualControllerView : ABXYButtonDelegate {
    func touch(_ buttonType: ABXYButton.ButtonType, _ touchType: TouchType) {
        guard let abxyButtonDelegate else {
            return
        }
        
        abxyButtonDelegate.touch(buttonType, touchType)
    }
}
