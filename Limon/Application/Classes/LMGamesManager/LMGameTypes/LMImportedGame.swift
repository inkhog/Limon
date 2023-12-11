//
//  LMImportedGame.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

import Foundation

struct LMImportedGame : Codable, Comparable, Hashable, Identifiable {
    var id = UUID()
    
    var isSystem: Bool = false
    let path, publisher, regions, size, title: String
    let icon: Data
    
    static func < (lhs: LMImportedGame, rhs: LMImportedGame) -> Bool {
        return lhs.title < rhs.title
    }
}
