//
//  BumperTriggerButton.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/18/23.
//

import Foundation
import UIKit

protocol BumperTriggerButtonDelegate {
    func touchDown(_ buttonType: BumperTriggerButton.ButtonType)
    func touchUpInside(_ buttonType: BumperTriggerButton.ButtonType)
}

class BumperTriggerButton : UIView {
    enum ButtonType : String {
        case l = "l.button.roundedbottom.horizontal", zl = "zl.button.roundedtop.horizontal", r = "r.button.roundedbottom.horizontal", zr = "zr.button.roundedtop.horizontal"
        
        var color: UIColor {
            .systemGray
        }
        
        var systemName: String {
            if #available(iOS 17, *) {
                "\(rawValue).fill"
            } else {
                let cleaned = rawValue.replacingOccurances(of: ".button", with: "")
                    .replacingOccurances(of: ".horizontal", with: "")
                return "\(cleaned).fill"
            }
        }
        
        var letter: String {
            rawValue
        }
    }
    
    var buttonType: ButtonType
    
    var letterImageView: UIImageView!
    
    init(_ buttonType: ButtonType) {
        self.buttonType = buttonType
        super.init(frame: .zero)
        
        letterImageView = .init(image: .init(systemName: buttonType.systemName)?
            .applyingSymbolConfiguration(.init(pointSize: 40, weight: .regular, scale: .large))?
            .applyingSymbolConfiguration(.init(paletteColors: [
                .white, buttonType.color
            ]))
        )
        letterImageView.translatesAutoresizingMaskIntoConstraints = false
        letterImageView.contentMode = .scaleAspectFill
        addSubview(letterImageView)
        addConstraints([
            letterImageView.topAnchor.constraint(equalTo: topAnchor),
            letterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            letterImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            letterImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func filled() {
        letterImageView.image = letterImageView.image?.applyingSymbolConfiguration(.init(paletteColors: [
            .white, buttonType.color
        ]))
    }
    
    func tinted() {
        letterImageView.image = letterImageView.image?.applyingSymbolConfiguration(.init(hierarchicalColor: buttonType.color))
    }
}
