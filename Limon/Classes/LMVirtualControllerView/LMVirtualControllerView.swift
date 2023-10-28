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
    
    var aButton, bButton, xButton, yButton: ABXYButton!
    var leftButton, downButton, upButton, rightButton: LDURButton!
    var selectButton, startButton: SelectStartButton!
    var lButton, zlButton, rButton, zrButton: BumperTriggerButton!
    
    var leftThumbstickView, rightThumbstickView: ThumbstickView!
    
    enum State {
        case activated, deactivated
    }
    
    enum Appearance {
        case filled, tinted
    }
    
    var appearance: Appearance = .filled
    var state: State = .activated
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideBumpersTriggers))
        //swipeDown.direction = .down
        //addGestureRecognizer(swipeDown)
        
        //let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(showBumpersTriggers))
        //swipeUp.direction = .up
        //addGestureRecognizer(swipeUp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func hideBumpersTriggers() {
        if #available(iOS 17, *) {
            lButton.letterImageView.addSymbolEffect(.disappear)
            zlButton.letterImageView.addSymbolEffect(.disappear)
            rButton.letterImageView.addSymbolEffect(.disappear)
            zrButton.letterImageView.addSymbolEffect(.disappear)
        } else {
            UIView.animate(withDuration: 0.2) {
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
        if #available(iOS 17, *) {
            lButton.letterImageView.addSymbolEffect(.appear)
            zlButton.letterImageView.addSymbolEffect(.appear)
            rButton.letterImageView.addSymbolEffect(.appear)
            zrButton.letterImageView.addSymbolEffect(.appear)
        } else {
            UIView.animate(withDuration: 0.2) {
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
    
    func addAButton() {
        aButton = .init(.a)
        aButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(aButton)
        
        addConstraints([
            aButton.widthAnchor.constraint(equalToConstant: 50),
            aButton.heightAnchor.constraint(equalToConstant: 50),
            aButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -88),
            aButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func addBButton() {
        bButton = .init(.b)
        bButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bButton)
        
        addConstraints([
            bButton.widthAnchor.constraint(equalToConstant: 50),
            bButton.heightAnchor.constraint(equalToConstant: 50),
            bButton.topAnchor.constraint(equalTo: aButton.safeAreaLayoutGuide.bottomAnchor),
            bButton.trailingAnchor.constraint(equalTo: aButton.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    func addXButton() {
        xButton = .init(.x)
        xButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(xButton)
        
        addConstraints([
            xButton.widthAnchor.constraint(equalToConstant: 50),
            xButton.heightAnchor.constraint(equalToConstant: 50),
            xButton.bottomAnchor.constraint(equalTo: aButton.safeAreaLayoutGuide.topAnchor),
            xButton.trailingAnchor.constraint(equalTo: aButton.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    func addYButton() {
        yButton = .init(.y)
        yButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(yButton)
        
        addConstraints([
            yButton.widthAnchor.constraint(equalToConstant: 50),
            yButton.heightAnchor.constraint(equalToConstant: 50),
            yButton.topAnchor.constraint(equalTo: aButton.safeAreaLayoutGuide.topAnchor),
            yButton.trailingAnchor.constraint(equalTo: xButton.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    
    func addLeftButton() {
        leftButton = .init(.left)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leftButton)
        
        addConstraints([
            leftButton.widthAnchor.constraint(equalToConstant: 50),
            leftButton.heightAnchor.constraint(equalToConstant: 50),
            leftButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -88),
            leftButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }
    
    func addDownButton() {
        downButton = .init(.down)
        downButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(downButton)
        
        addConstraints([
            downButton.widthAnchor.constraint(equalToConstant: 50),
            downButton.heightAnchor.constraint(equalToConstant: 50),
            downButton.topAnchor.constraint(equalTo: leftButton.safeAreaLayoutGuide.bottomAnchor),
            downButton.leadingAnchor.constraint(equalTo: leftButton.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func addUpButton() {
        upButton = .init(.up)
        upButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(upButton)
        
        addConstraints([
            upButton.widthAnchor.constraint(equalToConstant: 50),
            upButton.heightAnchor.constraint(equalToConstant: 50),
            upButton.bottomAnchor.constraint(equalTo: leftButton.safeAreaLayoutGuide.topAnchor),
            upButton.leadingAnchor.constraint(equalTo: leftButton.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func addRightButton() {
        rightButton = .init(.right)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightButton)
        
        addConstraints([
            rightButton.widthAnchor.constraint(equalToConstant: 50),
            rightButton.heightAnchor.constraint(equalToConstant: 50),
            rightButton.topAnchor.constraint(equalTo: leftButton.safeAreaLayoutGuide.topAnchor),
            rightButton.leadingAnchor.constraint(equalTo: upButton.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    
    func addSelectButton() {
        selectButton = .init(.select)
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectButton)
        
        addConstraints([
            selectButton.widthAnchor.constraint(equalToConstant: 40),
            selectButton.heightAnchor.constraint(equalToConstant: 40),
            selectButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            // selectButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: -10)
            selectButton.leadingAnchor.constraint(equalTo: downButton.trailingAnchor, constant: 10)
        ])
    }
    
    func addStartButton() {
        startButton = .init(.start)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(startButton)
        
        addConstraints([
            startButton.widthAnchor.constraint(equalToConstant: 40),
            startButton.heightAnchor.constraint(equalToConstant: 40),
            startButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            // startButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: 10)
            startButton.trailingAnchor.constraint(equalTo: bButton.leadingAnchor, constant: -10)
        ])
    }
    
    
    func addLButton() {
        lButton = .init(.l)
        lButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lButton)
        
        addConstraints([
            lButton.widthAnchor.constraint(equalToConstant: 56),
            lButton.heightAnchor.constraint(equalToConstant: 48),
            lButton.bottomAnchor.constraint(equalTo: upButton.safeAreaLayoutGuide.topAnchor, constant: -20),
            lButton.leadingAnchor.constraint(equalTo: leftButton.safeAreaLayoutGuide.leadingAnchor)
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
            rButton.bottomAnchor.constraint(equalTo: xButton.safeAreaLayoutGuide.topAnchor, constant: -20),
            rButton.trailingAnchor.constraint(equalTo: aButton.safeAreaLayoutGuide.trailingAnchor)
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
        insertSubview(leftThumbstickView, belowSubview: leftButton)
        
        addConstraints([
            leftThumbstickView.topAnchor.constraint(equalTo: upButton.topAnchor),
            leftThumbstickView.leadingAnchor.constraint(equalTo: leftButton.leadingAnchor),
            leftThumbstickView.bottomAnchor.constraint(equalTo: downButton.bottomAnchor),
            leftThumbstickView.trailingAnchor.constraint(equalTo: rightButton.trailingAnchor)
        ])
    }
    
    func addRightThumbstickView() {
        rightThumbstickView = .init(.right)
        rightThumbstickView.translatesAutoresizingMaskIntoConstraints = false
        rightThumbstickView.delegate = rightThumbstickViewDelegate
        addSubview(rightThumbstickView)
        insertSubview(rightThumbstickView, belowSubview: aButton)
        
        addConstraints([
            rightThumbstickView.topAnchor.constraint(equalTo: xButton.topAnchor),
            rightThumbstickView.leadingAnchor.constraint(equalTo: yButton.leadingAnchor),
            rightThumbstickView.bottomAnchor.constraint(equalTo: bButton.bottomAnchor),
            rightThumbstickView.trailingAnchor.constraint(equalTo: aButton.trailingAnchor)
        ])
    }
    
    
    func hide() {
        state = .deactivated
        
        if #available(iOS 17, *) {
            aButton.letterImageView.addSymbolEffect(.disappear)
            bButton.letterImageView.addSymbolEffect(.disappear)
            xButton.letterImageView.addSymbolEffect(.disappear)
            yButton.letterImageView.addSymbolEffect(.disappear)
            
            leftButton.letterImageView.addSymbolEffect(.disappear)
            downButton.letterImageView.addSymbolEffect(.disappear)
            upButton.letterImageView.addSymbolEffect(.disappear)
            rightButton.letterImageView.addSymbolEffect(.disappear)
            
            selectButton.letterImageView.addSymbolEffect(.disappear)
            startButton.letterImageView.addSymbolEffect(.disappear)
            
            lButton.letterImageView.addSymbolEffect(.disappear)
            zlButton.letterImageView.addSymbolEffect(.disappear)
            rButton.letterImageView.addSymbolEffect(.disappear)
            zrButton.letterImageView.addSymbolEffect(.disappear)
        } else {
            UIView.animate(withDuration: 0.2) {
                self.aButton.alpha = 0
                self.bButton.alpha = 0
                self.xButton.alpha = 0
                self.yButton.alpha = 0
                
                self.leftButton.alpha = 0
                self.downButton.alpha = 0
                self.upButton.alpha = 0
                self.rightButton.alpha = 0
                
                self.selectButton.alpha = 0
                self.startButton.alpha = 0
                
                self.lButton.alpha = 0
                self.zlButton.alpha = 0
                self.rButton.alpha = 0
                self.zrButton.alpha = 0
            }
        }
    }
    
    func show() {
        state = .activated
        
        if #available(iOS 17, *) {
            aButton.letterImageView.addSymbolEffect(.appear)
            bButton.letterImageView.addSymbolEffect(.appear)
            xButton.letterImageView.addSymbolEffect(.appear)
            yButton.letterImageView.addSymbolEffect(.appear)
            
            leftButton.letterImageView.addSymbolEffect(.appear)
            downButton.letterImageView.addSymbolEffect(.appear)
            upButton.letterImageView.addSymbolEffect(.appear)
            rightButton.letterImageView.addSymbolEffect(.appear)
            
            selectButton.letterImageView.addSymbolEffect(.appear)
            startButton.letterImageView.addSymbolEffect(.appear)
            
            lButton.letterImageView.addSymbolEffect(.appear)
            zlButton.letterImageView.addSymbolEffect(.appear)
            rButton.letterImageView.addSymbolEffect(.appear)
            zrButton.letterImageView.addSymbolEffect(.appear)
        } else {
            UIView.animate(withDuration: 0.2) {
                self.aButton.alpha = 1
                self.bButton.alpha = 1
                self.xButton.alpha = 1
                self.yButton.alpha = 1
                
                self.leftButton.alpha = 1
                self.downButton.alpha = 1
                self.upButton.alpha = 1
                self.rightButton.alpha = 1
                
                self.selectButton.alpha = 1
                self.startButton.alpha = 1
                
                self.lButton.alpha = 1
                self.zlButton.alpha = 1
                self.rButton.alpha = 1
                self.zrButton.alpha = 1
            }
        }
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        state == .activated ? super.hitTest(point, with: event) == self ? nil : super.hitTest(point, with: event) : nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard state == .activated, let abxyButtonDelegate, let ldurButtonDelegate, let selectStartButtonDelegate, let bumperTriggerButtonDelegate, let touch = touches.first else {
            return
        }
        
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        
        switch touch.view {
        case aButton:
            abxyButtonDelegate.touchDown(.a)
        case bButton:
            abxyButtonDelegate.touchDown(.b)
        case xButton:
            abxyButtonDelegate.touchDown(.x)
        case yButton:
            abxyButtonDelegate.touchDown(.y)
        case leftButton:
            ldurButtonDelegate.touchDown(.left)
        case downButton:
            ldurButtonDelegate.touchDown(.down)
        case upButton:
            ldurButtonDelegate.touchDown(.up)
        case rightButton:
            ldurButtonDelegate.touchDown(.right)
        case selectButton:
            selectStartButtonDelegate.touchDown(.select)
        case startButton:
            selectStartButtonDelegate.touchDown(.start)
        case lButton:
            bumperTriggerButtonDelegate.touchDown(.l)
        case zlButton:
            bumperTriggerButtonDelegate.touchDown(.zl)
        case rButton:
            bumperTriggerButtonDelegate.touchDown(.r)
        case zrButton:
            bumperTriggerButtonDelegate.touchDown(.zr)
        default:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard state == .activated, let abxyButtonDelegate, let ldurButtonDelegate, let selectStartButtonDelegate, let bumperTriggerButtonDelegate, let touch = touches.first else {
            return
        }
        
        switch touch.view {
        case aButton:
            abxyButtonDelegate.touchUpInside(.a)
        case bButton:
            abxyButtonDelegate.touchUpInside(.b)
        case xButton:
            abxyButtonDelegate.touchUpInside(.x)
        case yButton:
            abxyButtonDelegate.touchUpInside(.y)
        case leftButton:
            ldurButtonDelegate.touchUpInside(.left)
        case downButton:
            ldurButtonDelegate.touchUpInside(.down)
        case upButton:
            ldurButtonDelegate.touchUpInside(.up)
        case rightButton:
            ldurButtonDelegate.touchUpInside(.right)
        case selectButton:
            selectStartButtonDelegate.touchUpInside(.select)
        case startButton:
            selectStartButtonDelegate.touchUpInside(.start)
        case lButton:
            bumperTriggerButtonDelegate.touchUpInside(.l)
        case zlButton:
            bumperTriggerButtonDelegate.touchUpInside(.zl)
        case rButton:
            bumperTriggerButtonDelegate.touchUpInside(.r)
        case zrButton:
            bumperTriggerButtonDelegate.touchUpInside(.zr)
        default:
            break
        }
    }
    
    func filled() {
        appearance = .filled
        
        aButton.filled()
        bButton.filled()
        xButton.filled()
        yButton.filled()
        
        leftButton.filled()
        downButton.filled()
        upButton.filled()
        rightButton.filled()
        
        selectButton.filled()
        startButton.filled()
        
        lButton.filled()
        zlButton.filled()
        rButton.filled()
        zrButton.filled()
    }
    
    func tinted() {
        appearance = .tinted
        
        aButton.tinted()
        bButton.tinted()
        xButton.tinted()
        yButton.tinted()
        
        leftButton.tinted()
        downButton.tinted()
        upButton.tinted()
        rightButton.tinted()
        
        selectButton.tinted()
        startButton.tinted()
        
        lButton.tinted()
        zlButton.tinted()
        rButton.tinted()
        zrButton.tinted()
    }
    
    func addAllButtons() {
        addAButton()
        addBButton()
        addXButton()
        addYButton()
        
        addLeftButton()
        addDownButton()
        addUpButton()
        addRightButton()
        
        addSelectButton()
        addStartButton()
        
        addLButton()
        addZLButton()
        addRButton()
        addZRButton()
        
        addLeftThumbstickView()
        addRightThumbstickView()
    }
}
