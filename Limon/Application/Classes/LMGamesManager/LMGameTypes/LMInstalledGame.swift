//
//  LMInstalledGame.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

import Foundation

struct LMInstalledGame : Codable, Comparable, Hashable, Identifiable {
    var id = UUID()
    
    let path, publisher, regions, size, title: String
    let icon: Data
    
    static func < (lhs: LMInstalledGame, rhs: LMInstalledGame) -> Bool {
        return lhs.title < rhs.title
    }
}
