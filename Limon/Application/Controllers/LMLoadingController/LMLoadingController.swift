//
//  LMLoadingController.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

import Foundation
import UIKit

class LMLoadingController : UIViewController {
    fileprivate let citra = LMCitra.shared()
    
    fileprivate var activityIndicatorView: UIActivityIndicatorView!
    
    override func loadView() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        view = visualEffectView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = view as! UIVisualEffectView
        
        activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.tintColor = .label
        view.contentView.addSubview(activityIndicatorView)
        view.addConstraints([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.contentView.safeAreaLayoutGuide.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.contentView.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicatorView.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Task {
            try LMGamesManager.shared.games()
            
            let imported = LMGamesManager.shared.installed.filter { $0.path.contains("/sdmc/") }
            let installed = LMGamesManager.shared.installed.filter { $0.path.contains("/roms/") }
            let system = LMGamesManager.shared.imported.filter { $0.isSystem && !$0.title.isEmpty }
            
            var sectionCount = 0
            if !imported.isEmpty {
                sectionCount += 1
            }
            
            if !installed.isEmpty {
                sectionCount += 1
            }
            
            if !system.isEmpty {
                sectionCount += 1
            }
            
            let gamesController = UINavigationController(rootViewController: LMGamesController(LMGamesControllerLayout.shared.collectionViewLayout(sectionCount),
                                                                                               (imported: imported, installed: installed, system: system)))
            gamesController.modalPresentationStyle = .fullScreen
            present(gamesController, animated: true)
        }
    }
}
