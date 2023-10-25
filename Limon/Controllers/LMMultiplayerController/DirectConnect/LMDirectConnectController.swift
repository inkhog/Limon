//
//  LMDirectConnectController.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/24/23.
//

import Foundation
import UIKit

class LMDirectConnectController : LMLargeImageTitleController {
    var nicknameTextField, ipAddressTextField,
        portTextField, passwordTextField: LMMinimalRoundedTextField!
    var cancelButton, connectButton: UIButton!
    
    var keyboardHiddenConstraints, keyboardShownConstraints: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addSubviewConstraints()
        registerKeyboardNotifications()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // MARK: START ADD SUBVIEWS
    fileprivate func addSubviews() {
        nicknameTextField = .init("Nickname", .all)
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameTextField)
        
        ipAddressTextField = .init("IP address", .top)
        ipAddressTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ipAddressTextField)
        
        portTextField = .init("Port (optional)", .bottom)
        portTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(portTextField)
        
        passwordTextField = .init("Password (optional)", .all)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextField)
        
        
        var cancelConfiguration = UIButton.Configuration.borderless()
        cancelConfiguration.attributedTitle = .init("Cancel", attributes: .init([
            .font : UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)
        ]))
        cancelConfiguration.buttonSize = .large
        
        cancelButton = .init(configuration: cancelConfiguration, primaryAction: .init(handler: { _ in self.dismiss(animated: true) }))
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        
        
        var connectConfiguration = UIButton.Configuration.filled()
        connectConfiguration.attributedTitle = .init("Connect", attributes: .init([
            .font : UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)
        ]))
        connectConfiguration.buttonSize = .large
        connectConfiguration.cornerStyle = .large
        
        connectButton = .init(configuration: connectConfiguration, primaryAction: .init(handler: { _ in
            guard let delegate = self.delegate() else {
                return
            }
            
            guard let nickname = self.nicknameTextField.text, !nickname.isEmpty else {
                self.nicknameTextField.error()
                return
            }
            
            guard let ipAddress = self.ipAddressTextField.text, !ipAddress.isEmpty else {
                self.ipAddressTextField.error()
                return
            }
            
            self.dismiss(animated: true) {
                self.multiplayer().directConnect(nickname, ipAddress: ipAddress, port: self.portTextField.text, password: self.passwordTextField.text,
                                                 onRoomStateChanged: delegate.onRoomStateChanged(state:))
            }
        }))
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(connectButton)
    }
    // MARK: END ADD SUBVIEWS
    
    
    
    // MARK: START ADD SUBVIEW CONSTRAINTS
    fileprivate func addSubviewConstraints() {
        keyboardHiddenConstraints = nicknameTextField.topAnchor.constraint(equalTo: subtitleString == nil ? titleLabel.bottomAnchor : subtitleLabel.bottomAnchor, constant: 20)
        keyboardShownConstraints = nicknameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20)
        view.addConstraints([
            keyboardHiddenConstraints,
            nicknameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nicknameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            ipAddressTextField.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 20),
            ipAddressTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            ipAddressTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            ipAddressTextField.heightAnchor.constraint(equalToConstant: 50),
            
            portTextField.topAnchor.constraint(equalTo: ipAddressTextField.bottomAnchor, constant: 2),
            portTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            portTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            portTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: portTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            connectButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            connectButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -20),
            connectButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    // MARK: END ADD SUBVIEW CONSTRAINTS
    
    
    
    // MARK: START REGISTER KEYBOARD NOTIFICATIONS
    fileprivate func registerKeyboardNotifications() {
        if traitCollection.userInterfaceIdiom == .phone {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main, using: keyboardWillHide(_:))
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main, using: keyboardWillShow(_:))
        }
    }
    // MARK: END REGISTER KEYBOARD NOTIFICATIONS
    
    
    
    // MARK: START KEYBOARD NOTIFICATIONS
    fileprivate func keyboardWillHide(_ notification: Notification) {
        view.removeConstraint(keyboardShownConstraints)
        view.addConstraint(keyboardHiddenConstraints)
        
        UIView.animate(withDuration: 0.2) {
            if let _ = self.subtitleString {
                self.subtitleLabel.alpha = 1
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func keyboardWillShow(_ notification: Notification) {
        view.removeConstraint(keyboardHiddenConstraints)
        view.addConstraint(keyboardShownConstraints)
        
        UIView.animate(withDuration: 0.2) {
            if let _ = self.subtitleString {
                self.subtitleLabel.alpha = 0
            }
            
            self.view.layoutIfNeeded()
        }
    }
    // MARK: END KEYBOARD NOTIFICATIONS
}
