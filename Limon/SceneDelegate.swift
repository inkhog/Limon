//
//  SceneDelegate.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/6/23.
//

import Toast
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: ToastWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        window = .init(windowScene: windowScene)
        guard let window else {
            return
        }
        
        guard let version = UIApplication.release, let build = UIApplication.build else {
            return
        }
        
        
        let welcomeController = OBWelcomeController(title: "What's New", detailText: "See what's been added, changed, fixed or removed in the latest version of Limón",
                                                    icon: .init(systemName: "app.badge.fill")?.applyingSymbolConfiguration(.init(paletteColors: [.systemRed, .tintColor])))
        welcomeController.set_shouldInlineButtontray(true)
        
        welcomeController.addBulletedListItem(withTitle: "Fixed Virtual Controller",
                                              description: "Fixed an issue where the virtual controller would be missing the L, ZL, R and ZR symbols on iOS 16",
                                              image: .init(systemName: "gamecontroller.fill"))
        welcomeController.addBulletedListItem(withTitle: "Improved Virtual Controller",
                                              description: "Partially rewrote the virtual controller to improve how the left and right thumbsticks are displayed and handled",
                                              image: .init(systemName: "gamecontroller.fill"))
        welcomeController.addBulletedListItem(withTitle: "Implemented Load, Save States",
                                              description: "Load and save states are here but be warned they may require a higher end device. Crashes on lower end devices are expected",
                                              image: .init(systemName: "gamecontroller.fill"))
        welcomeController.addBulletedListItem(withTitle: "Enhanced User Experience",
                                              description: "Added haptic feedback for successful and unsuccessful Direct Room connections and thumbstick activation and sped up animations for all custom user interface elements",
                                              image: .init(systemName: "gamecontroller.fill"))
        
        
        var acknowledgeButtonConfiguration = UIButton.Configuration.filled()
        acknowledgeButtonConfiguration.attributedTitle = .init("Acknowledge", attributes: .init([
            .font : UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)
        ]))
        acknowledgeButtonConfiguration.buttonSize = .large
        acknowledgeButtonConfiguration.cornerStyle = .large
        
        var dontShowAgainButtonConfiguration = UIButton.Configuration.borderless()
        dontShowAgainButtonConfiguration.attributedTitle = .init("Don't Show Again", attributes: .init([
            .font : UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize),
            .foregroundColor : UIColor.systemRed
        ]))
        dontShowAgainButtonConfiguration.buttonSize = .large
        
        welcomeController.buttonTray.add(.init(configuration: acknowledgeButtonConfiguration, primaryAction: .init(handler: { _ in
            UserDefaults.standard.set(true, forKey: "acknowledgedWhatsNew_\(version).\(build)")
            
            let loadingController = LMLoadingController()
            loadingController.modalPresentationStyle = .fullScreen
            welcomeController.present(loadingController, animated: true)
        })))
        welcomeController.buttonTray.add(.init(configuration: dontShowAgainButtonConfiguration, primaryAction: .init(handler: { _ in
            UserDefaults.standard.set(true, forKey: "dontShowWhatsNewAgain")
            
            let loadingController = LMLoadingController()
            loadingController.modalPresentationStyle = .fullScreen
            welcomeController.present(loadingController, animated: true)
        })))
        welcomeController.buttonTray.setCaptionText("v\(version).\(build)", style: 0)
        
        // UserDefaults.standard.removeObject(forKey: "acknowledgedWhatsNew_\(version).\(build)")
        window.rootViewController = UserDefaults.standard.bool(forKey: "dontShowWhatsNewAgain") ? LMLoadingController() : UserDefaults.standard.bool(forKey: "acknowledgedWhatsNew_\(version).\(build)") ? LMLoadingController() : welcomeController
        window.tintColor = .systemYellow
        window.makeKeyAndVisible()
        
        
        if !UserDefaults.standard.bool(forKey: "hasSetDefaultSettings") {
            setDefaultSettings()
            UserDefaults.standard.set(true, forKey: "hasSetDefaultSettings")
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        LMCitra.shared().pause()
    }
    
    
    /*
     func onChatMessageReceived(message: ChatMessage) {
        NotificationCenter.default.post(name: .init("onChatMessageReceived"), object: message)
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
    }
     */
    
    func onError() { // TODO: (antique) add a post notification to the emulation view controller
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
    func onRoomStateChanged(state: RoomState) {
        NotificationCenter.default.post(name: .init("onRoomStateChanged"), object: state)
        switch state {
        case .RSJoined:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        default:
            break
        }
    }
    
    fileprivate func setDefaultSettings() {
        UserDefaults.standard.set(false, forKey: "useCPUJIT")
        UserDefaults.standard.set(100, forKey: "cpuClockPercentage")
        UserDefaults.standard.set(true, forKey: "isNew3DS")
        
        UserDefaults.standard.set(0, forKey: "audioInputType")
        UserDefaults.standard.set(0, forKey: "audioOutputType")
        
        UserDefaults.standard.set(true, forKey: "spirvShaderGen")
        UserDefaults.standard.set(false, forKey: "asyncShaderCompilation")
        UserDefaults.standard.set(true, forKey: "asyncPresentation")
        UserDefaults.standard.set(true, forKey: "useHWShader")
        UserDefaults.standard.set(true, forKey: "useDiskShaderCache")
        UserDefaults.standard.set(true, forKey: "shadersAccurateMul")
        UserDefaults.standard.set(true, forKey: "useNewVSync")
        UserDefaults.standard.set(true, forKey: "useShaderJIT")
        UserDefaults.standard.set(1, forKey: "resolutionFactor")
        UserDefaults.standard.set(100, forKey: "frameLimit")
        UserDefaults.standard.set(0, forKey: "textureFilter")
        
        UserDefaults.standard.set(0, forKey: "stereoRender")
        UserDefaults.standard.set(0, forKey: "factor3D")
        UserDefaults.standard.set(0, forKey: "monoRender")
    }
}
