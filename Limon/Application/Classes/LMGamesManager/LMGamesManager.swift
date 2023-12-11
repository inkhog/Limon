//
//  LMGamesManager.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

import Foundation

class LMGamesManager {
    enum LMGamesManagerError : Error {
        case invalidDocumentsDirectoryURL
    }
    
    static let shared = LMGamesManager()
    fileprivate let citra = LMCitra.shared()
    
    var imported: [LMImportedGame] = []
    var installed: [LMInstalledGame] = []
    
    func reset() {
        imported.removeAll()
        installed.removeAll()
    }
    
    func games() throws {
        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw LMGamesManagerError.invalidDocumentsDirectoryURL
        }
        
        let romsDirectoryURL = documentsDirectoryURL.appendingPathComponent("roms", conformingTo: .directory)
        if !FileManager.default.fileExists(atPath: romsDirectoryURL.path) {
            try FileManager.default.createDirectory(at: romsDirectoryURL, withIntermediateDirectories: true)
        }
        
        // SMDC
        installed.append(contentsOf: citra.installedGamePaths()
            .reduce(into: [LMInstalledGame](), {
                guard let path = $1 as? String else {
                    return
                }
                
                $0.append(.init(path: path, publisher: self.citra.gameInformation.publisher(path: path), regions: self.citra.gameInformation.regions(path: path),
                                size: "", title: self.citra.gameInformation.title(path: path),
                                icon: Data(bytes: self.citra.gameInformation.icon(path: path), count: 48 * 48 * 8)))
            })
        )
        
        // NAND
        imported.append(contentsOf: citra.systemGamePaths()
            .reduce(into: [LMImportedGame](), {
                guard let path = $1 as? String else {
                    return
                }
                
                let icon = self.citra.gameInformation.icon(path: path)
                let data = Data(bytes: icon, count: 48 * 48 * 8)
                if (data.count > 0) {
                    $0.append(.init(isSystem: true, path: path, publisher: self.citra.gameInformation.publisher(path: path), regions: self.citra.gameInformation.regions(path: path),
                                    size: "", title: self.citra.gameInformation.title(path: path),
                                    icon: data))
                } else {
                    $0.append(.init(isSystem: true, path: path, publisher: self.citra.gameInformation.publisher(path: path), regions: self.citra.gameInformation.regions(path: path),
                                    size: "", title: self.citra.gameInformation.title(path: path),
                                    icon: UIImage(systemName: "circle.fill")!.pngData()!))
                }
            })
        )
        
        // ROMS
        installed.append(contentsOf: try FileManager.default.contentsOfDirectory(atPath: romsDirectoryURL.path)
            .filter { $0.contains(".3ds") || $0.contains(".app") || $0.contains(".cci") || $0.contains(".cxi") }
            .reduce(into: [LMInstalledGame]()) {
                let path = romsDirectoryURL.appendingPathComponent($1, conformingTo: .fileURL).path
                
                $0.append(.init(path: path, publisher: self.citra.gameInformation.publisher(path: path), regions: self.citra.gameInformation.regions(path: path),
                                size: "", title: self.citra.gameInformation.title(path: path),
                                icon: Data(bytes: self.citra.gameInformation.icon(path: path), count: 48 * 48 * 8)))
            }
        )
    }
}
