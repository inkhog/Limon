//
//  LMEmulationController+VirtualController.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/28/23.
//

import Foundation
import UIKit

extension LMEmulationController : ABXYButtonDelegate {
    func touch(_ buttonType: ABXYButton.ButtonType, _ touchType: TouchType) {
        switch buttonType {
        case .a:
            EmulationInput.buttonA.pressChangedHandler(nil, value: touchType == .down ? 1.0 : 0.0, pressed: touchType == .down)
        case .b:
            EmulationInput.buttonB.pressChangedHandler(nil, value: touchType == .down ? 1.0 : 0.0, pressed: touchType == .down)
        case .x:
            EmulationInput.buttonX.pressChangedHandler(nil, value: touchType == .down ? 1.0 : 0.0, pressed: touchType == .down)
        case .y:
            EmulationInput.buttonY.pressChangedHandler(nil, value: touchType == .down ? 1.0 : 0.0, pressed: touchType == .down)
        }
    }
}

extension LMEmulationController : LDURButtonDelegate {
    func touch(_ buttonType: LDURButton.ButtonType, _ touchType: TouchType) {
        switch buttonType {
        case .left:
            EmulationInput.dpadLeft.pressChangedHandler(nil, value: touchType == .down ? 1.0 : 0.0, pressed: touchType == .down)
        case .down:
            EmulationInput.dpadDown.pressChangedHandler(nil, value: touchType == .down ? 1.0 : 0.0, pressed: touchType == .down)
        case .up:
            EmulationInput.dpadUp.pressChangedHandler(nil, value: touchType == .down ? 1.0 : 0.0, pressed: touchType == .down)
        case .right:
            EmulationInput.dpadRight.pressChangedHandler(nil, value: touchType == .down ? 1.0 : 0.0, pressed: touchType == .down)
        }
    }
}

extension LMEmulationController : SelectStartButtonDelegate {
    func touch(_ buttonType: SelectStartButton.ButtonType, _ touchType: TouchType) {
        switch buttonType {
        case .select:
            EmulationInput.buttonSelect.pressChangedHandler(nil, value: touchType == .down ? 1.0 : 0.0, pressed: touchType == .down)
        case .start:
            EmulationInput.buttonStart.pressChangedHandler(nil, value: touchType == .down ? 1.0 : 0.0, pressed: touchType == .down)
        }
    }
}

extension LMEmulationController : BumperTriggerButtonDelegate {
    func touch(_ buttonType: BumperTriggerButton.ButtonType, _ touchType: TouchType) {
        switch buttonType {
        case .l:
            EmulationInput.buttonL.pressChangedHandler(nil, value: touchType == .down ? 1.0 : 0.0, pressed: touchType == .down)
        case .zl:
            EmulationInput.buttonZL.pressChangedHandler(nil, value: touchType == .down ? 1.0 : 0.0, pressed: touchType == .down)
        case .r:
            EmulationInput.buttonR.pressChangedHandler(nil, value: touchType == .down ? 1.0 : 0.0, pressed: touchType == .down)
        case .zr:
            EmulationInput.buttonZR.pressChangedHandler(nil, value: touchType == .down ? 1.0 : 0.0, pressed: touchType == .down)
        }
    }
}

extension LMEmulationController : ThumbstickViewDelegate {
    func touchesBegan(_ position: ThumbstickTouchPosition, for thumbstick: ThumbstickView.ThumbstickType) {
        switch thumbstick {
        case .left:
            virtualControllerView.hideLeftPadView()
        case .right:
            virtualControllerView.hideRightPadView()
        }
    }
    
    func touchesEnded(for thumbstick: ThumbstickView.ThumbstickType) {
        switch thumbstick {
        case .left:
            virtualControllerView.showLeftPadView()
            EmulationInput.leftThumbstick.valueChangedHandler(nil, x: 0, y: 0)
        case .right:
            virtualControllerView.showRightPadView()
            EmulationInput.rightThumstick.valueChangedHandler(nil, x: 0, y: 0)
        }
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
