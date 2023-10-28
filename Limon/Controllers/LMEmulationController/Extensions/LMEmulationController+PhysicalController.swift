//
//  LMEmulationController+PhysicalController.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/28/23.
//

import Foundation
import GameController
import UIKit

extension LMEmulationController {
    func physicalControllerDidConnect(_ notification: Notification) {
        guard let current = GCController.current, let extendedGamepad = current.extendedGamepad else {
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
        
        virtualControllerView.hide()
    }
    
    func physicalControllerDidDisconnect(_ notification: Notification) {
        virtualControllerView.show()
    }
}
