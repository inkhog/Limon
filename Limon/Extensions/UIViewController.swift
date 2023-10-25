//
//  UIViewController.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

import Foundation
import UIKit

extension UIViewController {
    func citra() -> LMCitra {
        LMCitra.shared()
    }
    
    func delegate() -> SceneDelegate? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {
            return nil
        }
        
        return delegate
    }
    
    func multiplayer() -> LMMultiplayer {
        LMMultiplayer.sharedInstance()
    }
    
    func useCustomBackgroundColor(_ backgroundColor: UIColor) {
        view.backgroundColor = backgroundColor
    }
    
    func useSystemBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    
    func wantsLargeNavigationTitle(_ bool: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = bool
    }
}
