//
//  UIApplication.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

import Foundation

extension UIApplication {
    static var build: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
    
    static var release: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
