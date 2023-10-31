//
//  LeftPadView.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/31/23.
//

import Foundation
import UIKit

class LeftPadView : UIView {
    var delegate: LDURButtonDelegate?
    var leftButton, downButton, upButton, rightButton: LDURButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        addLeftButton()
        addDownButton()
        addUpButton()
        addRightButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        super.hitTest(point, with: event) == self ? nil : super.hitTest(point, with: event)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let delegate, let touch = touches.first, let view = touch.view as? LDURButton else {
            return
        }
        
        delegate.touch(view.buttonType, .down)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let delegate, let touch = touches.first, let view = touch.view as? LDURButton else {
            return
        }
        
        delegate.touch(view.buttonType, .up)
    }
    
    
    fileprivate func addLeftButton() {
        leftButton = .init(.left)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leftButton)
        
        addConstraints([
            leftButton.widthAnchor.constraint(equalToConstant: 50),
            leftButton.heightAnchor.constraint(equalToConstant: 50),
            
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    fileprivate func addDownButton() {
        downButton = .init(.down)
        downButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(downButton)
        
        addConstraints([
            downButton.widthAnchor.constraint(equalToConstant: 50),
            downButton.heightAnchor.constraint(equalToConstant: 50),
            
            downButton.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor),
            downButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            leftButton.bottomAnchor.constraint(equalTo: downButton.topAnchor)
        ])
    }
    
    fileprivate func addUpButton() {
        upButton = .init(.up)
        upButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(upButton)
        
        addConstraints([
            upButton.widthAnchor.constraint(equalToConstant: 50),
            upButton.heightAnchor.constraint(equalToConstant: 50),
            
            upButton.topAnchor.constraint(equalTo: topAnchor),
            upButton.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor),
            upButton.bottomAnchor.constraint(equalTo: leftButton.topAnchor)
        ])
    }
    
    fileprivate func addRightButton() {
        rightButton = .init(.right)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightButton)
        
        addConstraints([
            rightButton.widthAnchor.constraint(equalToConstant: 50),
            rightButton.heightAnchor.constraint(equalToConstant: 50),
            
            rightButton.topAnchor.constraint(equalTo: upButton.bottomAnchor),
            rightButton.leadingAnchor.constraint(equalTo: upButton.trailingAnchor),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    
    func hide() {
        if #available(iOS 17, *) {
            leftButton.letterImageView.addSymbolEffect(.disappear)
            downButton.letterImageView.addSymbolEffect(.disappear)
            upButton.letterImageView.addSymbolEffect(.disappear)
            rightButton.letterImageView.addSymbolEffect(.disappear)
        } else {
            UIView.animate(withDuration: 0.1) {
                self.leftButton.alpha = 0
                self.downButton.alpha = 0
                self.upButton.alpha = 0
                self.rightButton.alpha = 0
            }
        }
    }
    
    func show() {
        if #available(iOS 17, *) {
            leftButton.letterImageView.addSymbolEffect(.appear)
            downButton.letterImageView.addSymbolEffect(.appear)
            upButton.letterImageView.addSymbolEffect(.appear)
            rightButton.letterImageView.addSymbolEffect(.appear)
        } else {
            UIView.animate(withDuration: 0.1) {
                self.leftButton.alpha = 1
                self.downButton.alpha = 1
                self.upButton.alpha = 1
                self.rightButton.alpha = 1
            }
        }
    }
    
    
    func filled() {
        leftButton.filled()
        downButton.filled()
        upButton.filled()
        rightButton.filled()
    }
    
    func tinted() {
        leftButton.tinted()
        downButton.tinted()
        upButton.tinted()
        rightButton.tinted()
    }
}
