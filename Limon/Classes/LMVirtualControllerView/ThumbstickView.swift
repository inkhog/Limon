//
//  ThumbstickView.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/28/23.
//

import Foundation
import UIKit

struct ThumbstickTouchPosition {
    let x, y: Float
}

protocol ThumbstickViewDelegate {
    func touchesBegan(_ position: ThumbstickTouchPosition, for thumbstick: ThumbstickView.ThumbstickType)
    func touchesEnded()
    func touchesMoved(_ position: ThumbstickTouchPosition, for thumbstick: ThumbstickView.ThumbstickType)
}

class ThumbstickView : UIView {
    var delegate: ThumbstickViewDelegate?
    
    enum ThumbstickType {
        case left, right
    }
    
    var thumbstickType: ThumbstickType
    init(_ thumbstickType: ThumbstickType) {
        self.thumbstickType = thumbstickType
        super.init(frame: .zero)
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let delegate, let touch = touches.first else {
            return
        }
        
        delegate.touchesBegan(position(from: touch.location(in: self)), for: thumbstickType)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let delegate else {
            return
        }
        
        delegate.touchesEnded()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let delegate, let touch = touches.first else {
            return
        }
        
        delegate.touchesMoved(position(from: touch.location(in: self)), for: thumbstickType)
    }
    
    
    fileprivate func position(from location: CGPoint) -> ThumbstickTouchPosition {
        let thumbstickRadius = frame.width / 2
        return .init(x: Float((location.x - thumbstickRadius) / thumbstickRadius), y: Float(-(location.y - thumbstickRadius) / thumbstickRadius))
    }
}
