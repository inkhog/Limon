//
//  LDURButton.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/18/23.
//

import Foundation
import UIKit

protocol LDURButtonDelegate {
    func touch(_ buttonType: LDURButton.ButtonType, _ touchType: TouchType)
}

class LDURButton : UIView {
    enum ButtonType : String {
        case left = "arrowtriangle.left", down = "arrowtriangle.down", up = "arrowtriangle.up", right = "arrowtriangle.right"
        
        var color: UIColor {
            .systemGray
        }
        
        var systemName: String {
            "\(rawValue).circle.fill"
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
