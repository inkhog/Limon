//
//  LMImportingController.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/18/23.
//

import Foundation
import UIKit

class LMImportingController : UIViewController {
    var captionLabel: UILabel!
    
    var url: URL
    init(_ url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        useSystemBackgroundColor()
        addSubviews()
        addSubviewConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LMGameImporter.shared().importCIA(from: url) { status in
            guard let presentingViewController = self.presentingViewController else {
                return
            }
            
            LMGamesManager.shared.reset()
            
            self.dismiss(animated: true) {
                let loadingNavigationController = UINavigationController(rootViewController: LMLoadingController())
                loadingNavigationController.modalPresentationStyle = .fullScreen
                presentingViewController.present(loadingNavigationController, animated: true)
            }
        }
    }
    
    // MARK: START ADD SUBVIEWS
    fileprivate func addSubviews() {
        var textStyle: UIFont.TextStyle
        if #available(iOS 17, *) {
            textStyle = .extraLargeTitle
        } else {
            textStyle = .largeTitle
        }
        
        captionLabel = .init()
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.attributedText = .init(string: "Installing", attributes: [
            .font : UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: textStyle).pointSize),
            .foregroundColor : UIColor.label
        ])
        view.addSubview(captionLabel)
    }
    // MARK: END ADD SUBVIEWS
    
    
    
    // MARK: START ADD SUBVIEW CONSTRAINTS
    fileprivate func addSubviewConstraints() {
        view.addConstraints([
            captionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            captionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            captionLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            captionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    // MARK: END ADD SUBVIEW CONSTRAINTS
}
