//
//  RightPadView.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/31/23.
//

import Foundation
import UIKit

class RightPadView : UIView {
    var delegate: ABXYButtonDelegate?
    
    var aButton, bButton, xButton, yButton: ABXYButton!
    var startButton: SelectStartButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        addAButton()
        addBButton()
        addXButton()
        addYButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        super.hitTest(point, with: event) == self ? nil : super.hitTest(point, with: event)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let delegate, let touch = touches.first, let view = touch.view as? ABXYButton else {
            return
        }
        
        delegate.touch(view.buttonType, .down)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let delegate, let touch = touches.first, let view = touch.view as? ABXYButton else {
            return
        }
        
        delegate.touch(view.buttonType, .up)
    }
    
    
    fileprivate func addAButton() {
        aButton = .init(.a)
        aButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(aButton)
        
        addConstraints([
            aButton.widthAnchor.constraint(equalToConstant: 50),
            aButton.heightAnchor.constraint(equalToConstant: 50),
            
            aButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    fileprivate func addBButton() {
        bButton = .init(.b)
        bButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bButton)
        
        addConstraints([
            bButton.widthAnchor.constraint(equalToConstant: 50),
            bButton.heightAnchor.constraint(equalToConstant: 50),
            
            bButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            bButton.trailingAnchor.constraint(equalTo: aButton.leadingAnchor),
            
            aButton.bottomAnchor.constraint(equalTo: bButton.topAnchor)
        ])
    }
    
    fileprivate func addXButton() {
        xButton = .init(.x)
        xButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(xButton)
        
        addConstraints([
            xButton.widthAnchor.constraint(equalToConstant: 50),
            xButton.heightAnchor.constraint(equalToConstant: 50),
            
            xButton.topAnchor.constraint(equalTo: topAnchor),
            xButton.trailingAnchor.constraint(equalTo: aButton.leadingAnchor),
            xButton.bottomAnchor.constraint(equalTo: aButton.topAnchor)
        ])
    }
    
    fileprivate func addYButton() {
        yButton = .init(.y)
        yButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(yButton)
        
        addConstraints([
            yButton.widthAnchor.constraint(equalToConstant: 50),
            yButton.heightAnchor.constraint(equalToConstant: 50),
            
            yButton.topAnchor.constraint(equalTo: xButton.bottomAnchor),
            yButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            yButton.trailingAnchor.constraint(equalTo: xButton.leadingAnchor)
        ])
    }
    
    
    func hide() {
        if #available(iOS 17, *) {
            aButton.letterImageView.addSymbolEffect(.disappear)
            bButton.letterImageView.addSymbolEffect(.disappear)
            xButton.letterImageView.addSymbolEffect(.disappear)
            yButton.letterImageView.addSymbolEffect(.disappear)
        } else {
            UIView.animate(withDuration: 0.1) {
                self.aButton.alpha = 0
                self.bButton.alpha = 0
                self.xButton.alpha = 0
                self.yButton.alpha = 0
            }
        }
    }
    
    func show() {
        if #available(iOS 17, *) {
            aButton.letterImageView.addSymbolEffect(.appear)
            bButton.letterImageView.addSymbolEffect(.appear)
            xButton.letterImageView.addSymbolEffect(.appear)
            yButton.letterImageView.addSymbolEffect(.appear)
        } else {
            UIView.animate(withDuration: 0.1) {
                self.aButton.alpha = 1
                self.bButton.alpha = 1
                self.xButton.alpha = 1
                self.yButton.alpha = 1
            }
        }
    }
    
    
    func filled() {
        aButton.filled()
        bButton.filled()
        xButton.filled()
        yButton.filled()
    }
    
    func tinted() {
        aButton.tinted()
        bButton.tinted()
        xButton.tinted()
        yButton.tinted()
    }
}
