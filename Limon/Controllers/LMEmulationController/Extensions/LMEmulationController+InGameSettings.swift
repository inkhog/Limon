//
//  LMEmulationController+InGameSettings.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/28/23.
//

import Foundation
import UIKit

extension LMEmulationController {
    func reloadInGameSettingsMenu() {
        Task {
            inGameSettingsButton.menu = inGameSettingsMenu()
        }
    }
    
    
    fileprivate func appearanceSubmenu() -> UIMenu {
        func children() -> [UIMenuElement] {
            func children() -> [UIMenuElement] {
                [
                    UIAction(title: "Filled", image: .init(systemName: "drop.fill"), attributes: self.virtualControllerView.appearance == .filled ? [.disabled] : [], handler: { _ in
                        self.virtualControllerView.filled()
                        self.reloadInGameSettingsMenu()
                    }),
                    UIAction(title: "Tinted", image: .init(systemName: "drop.halffull"), attributes: self.virtualControllerView.appearance == .filled ? [] : [.disabled], handler: { _ in
                        self.virtualControllerView.tinted()
                        self.reloadInGameSettingsMenu()
                    })
                ]
            }
            
            func isLatestVersion() -> Bool {
                if #available(iOS 17, *) { true } else { false }
            }
            
            let menu: UIMenu = if #available(iOS 16, *) {
                .init(options: .displayInline, preferredElementSize: .medium, children: children())
            } else {
                .init(options: .displayInline, children: children())
            }
            
            return [
                menu,
                UIAction(title: "Toggle L, ZL, R, ZR", image: .init(systemName: self.virtualControllerView.bumpersTriggersHidden ? "eye.fill" : "eye.slash.fill"), handler: { _ in
                    self.virtualControllerView.bumpersTriggersHidden ? self.virtualControllerView.showBumpersTriggers() : self.virtualControllerView.hideBumpersTriggers()
                    self.reloadInGameSettingsMenu()
                })
            ]
        }
        
        return .init(title: "Appearance", image: .init(systemName: "paintpalette.fill"), children: children())
    }
    
    fileprivate func multiplayerSubmenu() -> UIMenu {
        func children() -> [UIMenuElement] {
            var action: UIAction
            if multiplayer().connected {
                action = .init(title: "Leave", image: .init(systemName: "xmark.circle.fill"), handler: { _ in
                    self.multiplayer().leave()
                    self.reloadInGameSettingsMenu()
                })
            } else {
                action = .init(title: "Direct Connect", image: .init(systemName: "person.line.dotted.person.fill"), handler: { _ in
                    self.citra().pause()
                    self.reloadInGameSettingsMenu()
                    
                    let directConnectController = LMDirectConnectController(.init(systemName: "person.line.dotted.person.fill"), "Direct Connect",
                        "Connect directly to a multiplayer room by entering your nickname along with the room's IP address, port if non-default and password if password protected")
                    directConnectController.modalPresentationStyle = .fullScreen
                    self.present(directConnectController, animated: true)
                })
            }
            
            let menu: UIMenu = if #available(iOS 16, *) {
                .init(options: .displayInline, preferredElementSize: .medium, children: [
                    UIAction(title: "Browse Servers", image: .init(systemName: "globe.asia.australia.fill"), attributes: .disabled, handler: { _ in }),
                    action
                ])
            } else {
                .init(options: .displayInline, children: [
                    UIAction(title: "Browse Servers", image: .init(systemName: "globe.asia.australia.fill"), attributes: .disabled, handler: { _ in }),
                    action
                ])
            }
            
            return [
                menu
            ]
        }
        
        return .init(title: "Multiplayer", image: .init(systemName: "person.3.fill"), children: children())
    }
    
    fileprivate func screenLayoutsSubmenu() -> UIMenu {
        func children() -> [UIMenuElement] {
            func children() -> [UIMenuElement] {
                let screenLayouts = [
                    (title: "Default", subtitle: "", value: 0),
                    (title: "Single Screen", subtitle: "One large screen, centered", value: 1),
                    (title: "Large Screen", subtitle: "One large screen, one small screen, side by side", value: 2),
                    (title: "Side by Side Screen", subtitle: "Two equal height screens, side by side", value: 3),
                    (title: "Hybrid Screen", subtitle: "One large screen, two small screens, side by side, top to bottom", value: 5),
                    (title: "Mobile Portrait", subtitle: "Same as Default", value: 6),
                    (title: "Mobile Landscape", subtitle: "Same as Default, resized", value: 7)
                ]
                
                return screenLayouts.reduce(into: [UIAction]()) { partialResult, screenLayout in
                    partialResult.append(.init(title: screenLayout.title, subtitle: screenLayout.subtitle, state: self.citra()._layoutOption == screenLayout.value ? .on : .off, handler: { _ in
                        self.citra().setLayoutOption(UInt(screenLayout.value), with: self.screenView.screen.layer as! CAMetalLayer)
                        self.reloadInGameSettingsMenu()
                    }))
                }
            }
            
            let menu: UIMenu = if #available(iOS 16, *) {
                .init(options: .displayInline, preferredElementSize: .medium, children: [
                    UIMenu(title: "Screen Layouts", image: .init(systemName: "rectangle.3.group.fill"), children: children()),
                    UIAction(title: "Swap Screens", image: .init(systemName: "rectangle.2.swap"), handler: { _ in
                        self.citra().swapScreens(self.screenView.screen.layer as! CAMetalLayer)
                    })
                ])
            } else {
                .init(options: .displayInline, children: [
                    UIMenu(title: "Screen Layouts", image: .init(systemName: "rectangle.3.group.fill"), children: children()),
                    UIAction(title: "Swap Screens", image: .init(systemName: "rectangle.2.swap"), handler: { _ in
                        self.citra().swapScreens(self.screenView.screen.layer as! CAMetalLayer)
                    })
                ])
            }
            
            return [
                menu
            ]
        }
        
        return .init(title: "Screen Layout", image: .init(systemName: "rectangle.3.group.fill"), children: children())
    }
    
    fileprivate func statesSubmenu() -> UIMenu {
        func children() -> [UIMenuElement] {
            func children() -> [UIMenuElement] {
                let states: [(title: String, systemName: String, handler: UIActionHandler)] = [
                    (title: "Load State", systemName: "arrow.up.doc.fill", handler: { _ in
                        let alertController = UIAlertController(title: "Save States", message: "Choose a save state to attempt to load it", preferredStyle: .actionSheet)
                        self.citra().saveStates().forEach { saveState in
                            if let saveState = saveState as? LMSaveState {
                                alertController.addAction(.init(title: saveState.title, style: .default, handler: { _ in
                                    self.citra().load(saveState.url)
                                    self.citra().prepareForLoad()
                                }))
                            }
                        }
                        alertController.addAction(.init(title: "Cancel", style: .cancel))
                        self.present(alertController, animated: true)
                    }),
                    (title: "Save State", systemName: "arrow.down.doc.fill", handler: { _ in
                        DispatchQueue.main.async {
                            self.citra().prepareForSave()
                        }
                    })
                ]
                
                return states.reduce(into: [UIAction](), { partialResult, state in
                    partialResult.append(.init(title: state.title, image: .init(systemName: state.systemName), handler: state.handler))
                })
            }
            
            let menu: UIMenu = if #available(iOS 16, *) {
                .init(options: .displayInline, preferredElementSize: .medium, children: children())
            } else {
                .init(options: .displayInline, children: children())
            }
            
            return [
                menu
            ]
        }
        
        return .init(title: "States", image: .init(systemName: "internaldrive.fill"), children: children())
    }
    
    fileprivate func emulationStatesSubmenu() -> UIMenu {
        func children() -> [UIMenuElement] {
            let states: [(title: String, systemName: String, attributes: UIMenuElement.Attributes, handler: UIActionHandler)] = [
                (title: "Pause", systemName: "pause.fill", attributes: self.citra().isPaused() ? [.disabled] : [], handler: { _ in
                    self.citra().pause()
                    self.reloadInGameSettingsMenu()
                }),
                (title: "Resume", systemName: "play.fill", attributes: self.citra().isPaused() ? [] : [.disabled], handler: { _ in
                    self.citra().resume()
                    self.reloadInGameSettingsMenu()
                }),
                (title: "Stop", systemName: "stop.fill", attributes: [.disabled], handler: { _ in })
            ]
            
            return states.reduce(into: [UIAction]()) { partialResult, state in
                partialResult.append(.init(title: state.title, image: .init(systemName: state.systemName), attributes: state.attributes, handler: state.handler))
            }
        }
        
        let menu: UIMenu = if #available(iOS 16, *) {
            .init(options: .displayInline, preferredElementSize: .small, children: children())
        } else {
            .init(options: .displayInline, children: children())
        }
        
        return menu
    }
    
    func inGameSettingsMenu() -> UIMenu {
        .init(children: [appearanceSubmenu(), multiplayerSubmenu(), screenLayoutsSubmenu(), statesSubmenu(), emulationStatesSubmenu()])
    }
}
