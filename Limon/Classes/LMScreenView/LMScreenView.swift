//
//  LMScreenView.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

import Foundation
import MetalKit
import UIKit

class LMScreenView : UIView {
    var screen: MTKView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        screen = .init(frame: .zero, device: MTLCreateSystemDefaultDevice())
        screen.translatesAutoresizingMaskIntoConstraints = false
        addSubview(screen)
        
        addConstraints([
            screen.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            screen.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            screen.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            screen.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
