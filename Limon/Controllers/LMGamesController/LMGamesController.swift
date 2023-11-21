//
//  LMGamesController.swift
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

import AVFAudio
import Foundation
import UIKit

enum Section : String, CustomStringConvertible {
    case imported = "Imported"
    case installed = "Installed"
    case system = "System"
    
    var description: String {
        return rawValue
    }
}

enum MonoRender : Int, CustomStringConvertible {
    case leftEye = 0, rightEye = 1
    static let options = [leftEye, rightEye]
    
    var description: String {
        switch self {
        case .leftEye:
            "Left Eye"
        case .rightEye:
            "Right Eye"
        }
    }
}

enum StereoRender : Int, CustomStringConvertible {
    case off = 0, sideBySide = 1, anaglpyh = 2, interlaced = 3, reverseInterlaced = 4, cardboardVR = 5
    static let options = [off, sideBySide, anaglpyh, interlaced, reverseInterlaced, cardboardVR]
    
    var description: String {
        switch self {
        case .off:
            "Off"
        case .sideBySide:
            "Side By Side"
        case .anaglpyh:
            "Anaglyph"
        case .interlaced:
            "Interlaced"
        case .reverseInterlaced:
            "Reverse Interlaced"
        case .cardboardVR:
            "Cardboard VR"
        }
    }
}

enum TextureFilter : Int, CustomStringConvertible {
    case off = 0, anime4K = 1, bicubic = 2, nearestNeighbor = 3, scaleForce = 4, xbrz = 5, mmpx = 6
    static let filters = [off, anime4K, bicubic, nearestNeighbor, scaleForce, xbrz, mmpx]
    
    var description: String {
        switch self {
        case .off:
            "Off"
        case .anime4K:
            "Anime 4K"
        case .bicubic:
            "Bicubic"
        case .nearestNeighbor:
            "Nearest Neighbor"
        case .scaleForce:
            "ScaleForce"
        case .xbrz:
            "xBRZ"
        case .mmpx:
            "MMPX"
        }
    }
}

enum Resolution : Int, CustomStringConvertible {
    case r240 = 1, r480 = 2, r720 = 3, r960 = 4, r1200 = 5, r1440 = 6
    // 240, 480, 720, 960, 1200, 1440
    static let resolutions = [r240, r480, r720, r960, r1200, r1440]
    
    var description: String {
        "\(240 * rawValue)p"
    }
}


@objc class EmulationSettings : NSObject {
    @objc static var useCPUJIT: Bool = UserDefaults.standard.bool(forKey: "useCPUJIT")
    @objc static var cpuClockPercentage: Int = UserDefaults.standard.integer(forKey: "cpuClockPercentage")
    @objc static var isNew3DS: Bool = UserDefaults.standard.bool(forKey: "isNew3DS")
    
    @objc static var audioInputType: Int = UserDefaults.standard.integer(forKey: "audioInputType")
    @objc static var audioOutputType: Int = UserDefaults.standard.integer(forKey: "audioOutputType")

    @objc static var spirvShaderGen: Bool = UserDefaults.standard.bool(forKey: "spirvShaderGen")
    @objc static var asyncShaderCompilation: Bool = UserDefaults.standard.bool(forKey: "asyncShaderCompilation")
    @objc static var asyncShaderPresentation: Bool = UserDefaults.standard.bool(forKey: "asyncPresentation")
    @objc static var useHWShader: Bool = UserDefaults.standard.bool(forKey: "useHWShader")
    @objc static var useDiskShaderCache: Bool = UserDefaults.standard.bool(forKey: "useDiskShaderCache")
    @objc static var shadersAccurateMul: Bool = UserDefaults.standard.bool(forKey: "shadersAccurateMul")
    @objc static var useNewVSync: Bool = UserDefaults.standard.bool(forKey: "useNewVSync")
    @objc static var useShaderJIT: Bool = UserDefaults.standard.bool(forKey: "useShaderJIT")
    @objc static var resolutionFactor: Int = UserDefaults.standard.integer(forKey: "resolutionFactor")
    @objc static var frameLimit: Int = UserDefaults.standard.integer(forKey: "frameLimit")
    @objc static var textureFilter: Int = UserDefaults.standard.integer(forKey: "textureFilter")

    @objc static var stereoRender: Int = UserDefaults.standard.integer(forKey: "stereoRender")
    @objc static var factor3D: Int = UserDefaults.standard.integer(forKey: "factor3D")
    @objc static var monoRender: Int = UserDefaults.standard.integer(forKey: "monoRender")
    
    override init() {
        EmulationSettings.useCPUJIT = UserDefaults.standard.bool(forKey: "useCPUJIT")
        EmulationSettings.cpuClockPercentage = UserDefaults.standard.integer(forKey: "cpuClockPercentage")
        EmulationSettings.isNew3DS = UserDefaults.standard.bool(forKey: "isNew3DS")
        
        EmulationSettings.audioInputType = UserDefaults.standard.integer(forKey: "audioInputType")
        EmulationSettings.audioOutputType = UserDefaults.standard.integer(forKey: "audioOutputType")

        EmulationSettings.spirvShaderGen = UserDefaults.standard.bool(forKey: "spirvShaderGen")
        EmulationSettings.asyncShaderCompilation = UserDefaults.standard.bool(forKey: "asyncShaderCompilation")
        EmulationSettings.asyncShaderPresentation = UserDefaults.standard.bool(forKey: "asyncShaderPresentation")
        EmulationSettings.useHWShader = UserDefaults.standard.bool(forKey: "useHWShader")
        EmulationSettings.useDiskShaderCache = UserDefaults.standard.bool(forKey: "useDiskShaderCache")
        EmulationSettings.shadersAccurateMul = UserDefaults.standard.bool(forKey: "shadersAccurateMul")
        EmulationSettings.useNewVSync = UserDefaults.standard.bool(forKey: "useNewVSync")
        EmulationSettings.useShaderJIT = UserDefaults.standard.bool(forKey: "useShaderJIT")
        EmulationSettings.resolutionFactor = UserDefaults.standard.integer(forKey: "resolutionFactor")
        EmulationSettings.frameLimit = UserDefaults.standard.integer(forKey: "frameLimit")
        EmulationSettings.textureFilter = UserDefaults.standard.integer(forKey: "textureFilter")

        EmulationSettings.stereoRender = UserDefaults.standard.integer(forKey: "stereoRender")
        EmulationSettings.factor3D = UserDefaults.standard.integer(forKey: "factor3D")
        EmulationSettings.monoRender = UserDefaults.standard.integer(forKey: "monoRender")
    }
    
    
    @objc func set(bool: Bool, for key: String, _ controller: UIViewController) {
        let old = UserDefaults.standard.bool(forKey: key)
        UserDefaults.standard.set(!old, forKey: key)
        
        if let gamesController = controller as? LMGamesController {
            gamesController.settings = .init()
            gamesController.navigationItem.setLeftBarButtonItems([
                .init(image: .init(systemName: "arrow.down.doc.fill"), primaryAction: .init(handler: { _ in
                    gamesController.openCIADocumentPicker()
                })),
                .init(image: .init(systemName: "gearshape.fill"), menu: gamesController.outOfGameSettingsMenu())
            ], animated: true)
        }
    }
    
    @objc func set(int: Int, for key: String, _ controller: UIViewController) {
        UserDefaults.standard.set(int, forKey: key)
        
        if let gamesController = controller as? LMGamesController {
            gamesController.settings = .init()
            gamesController.navigationItem.setLeftBarButtonItems([
                .init(image: .init(systemName: "arrow.down.doc.fill"), primaryAction: .init(handler: { _ in
                    gamesController.openCIADocumentPicker()
                })),
                .init(image: .init(systemName: "gearshape.fill"), menu: gamesController.outOfGameSettingsMenu())
            ], animated: true)
        }
    }
}


class LMGamesController : UICollectionViewController {
    fileprivate var items: (imported: [LMInstalledGame], installed: [LMInstalledGame], system: [LMImportedGame])
    
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil
    var snapshot: NSDiffableDataSourceSnapshot<Section, AnyHashable>! = nil
    
    var settings = EmulationSettings()
    
    var player: AVAudioPlayer? = nil
    
    init(_ collectionViewLayout: UICollectionViewLayout, _ items: (imported: [LMInstalledGame], installed: [LMInstalledGame], system: [LMImportedGame])) {
        self.items = items
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setLeftBarButtonItems([
            .init(image: .init(systemName: "arrow.down.doc.fill"), primaryAction: .init(handler: { _ in
                self.openCIADocumentPicker()
            })),
            .init(image: .init(systemName: "gearshape.fill"), menu: outOfGameSettingsMenu())
        ], animated: true)
        title = "Games"
        useSystemBackgroundColor()
        wantsLargeNavigationTitle(true)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        
        let importedCellRegistration = UICollectionView.CellRegistration<LMGameCell, LMInstalledGame> { cell, indexPath, itemIdentifier in
            cell.label.attributedText = .init(string: itemIdentifier.title, attributes: [
                .font : UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .headline).pointSize),
                .foregroundColor : UIColor.label
            ])
            cell.secondaryLabel.attributedText = .init(string: itemIdentifier.publisher, attributes: [
                .font : UIFont.preferredFont(forTextStyle: .subheadline),
                .foregroundColor : UIColor.secondaryLabel
            ])
            
            cell.imageView.image = itemIdentifier.icon.decodeRGB565(width: 48, height: 48)
        }
        
        let installedCellRegistration = UICollectionView.CellRegistration<LMGameCell, LMInstalledGame> { cell, indexPath, itemIdentifier in
            cell.label.attributedText = .init(string: itemIdentifier.title, attributes: [
                .font : UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .headline).pointSize),
                .foregroundColor : UIColor.label
            ])
            cell.secondaryLabel.attributedText = .init(string: itemIdentifier.publisher, attributes: [
                .font : UIFont.preferredFont(forTextStyle: .subheadline),
                .foregroundColor : UIColor.secondaryLabel
            ])
            
            cell.imageView.image = itemIdentifier.icon.decodeRGB565(width: 48, height: 48)
        }
        
        let systemCellRegistration = UICollectionView.CellRegistration<LMGameCell, LMImportedGame> { cell, indexPath, itemIdentifier in
            cell.label.attributedText = .init(string: itemIdentifier.title, attributes: [
                .font : UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .headline).pointSize),
                .foregroundColor : UIColor.label
            ])
            cell.secondaryLabel.attributedText = .init(string: itemIdentifier.publisher, attributes: [
                .font : UIFont.preferredFont(forTextStyle: .subheadline),
                .foregroundColor : UIColor.secondaryLabel
            ])
            
            cell.imageView.image = itemIdentifier.icon.decodeRGB565(width: 48, height: 48)
        }
        
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<LMSupplementaryView>(elementKind: UICollectionView.elementKindSectionHeader) {
            guard let section = self.dataSource.sectionIdentifier(for: $2.section) else {
                return
            }
            
            switch section {
            case .imported:
                let items = self.dataSource.snapshot().itemIdentifiers(inSection: .imported).count
                $0.set(section.description, "\(items) game cartridge\(items == 1 ? "" : "s") from /sdmc")
            case .installed:
                let items = self.dataSource.snapshot().itemIdentifiers(inSection: .installed).count
                $0.set(section.description, "\(items) game cartridge\(items == 1 ? "" : "s") from /roms")
            case .system:
                let items = self.dataSource.snapshot().itemIdentifiers(inSection: .system).count
                $0.set(section.description, "\(items) game cartridge\(items == 1 ? "" : "s") from /nand")
            }
        }
        
        
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) {
            switch $2 {
            case let imported as LMImportedGame:
                $0.dequeueConfiguredReusableCell(using: systemCellRegistration, for: $1, item: imported)
            case let importedInstalled as LMInstalledGame:
                if self.dataSource.sectionIdentifier(for: $1.section) ?? .imported == .imported {
                    $0.dequeueConfiguredReusableCell(using: importedCellRegistration, for: $1, item: importedInstalled)
                } else {
                    $0.dequeueConfiguredReusableCell(using: installedCellRegistration, for: $1, item: importedInstalled)
                }
            default:
                nil
            }
        }
        
        dataSource.supplementaryViewProvider = {
            $0.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: $2)
        }
        
        
        snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        Task {
            if !self.items.imported.isEmpty {
                snapshot.appendSections([.imported])
                snapshot.appendItems(self.items.imported.sorted(), toSection: .imported)
            }
            
            if !self.items.installed.isEmpty {
                snapshot.appendSections([.installed])
                snapshot.appendItems(self.items.installed.sorted(), toSection: .installed)
            }
            
            if !self.items.system.isEmpty {
                snapshot.appendSections([.system])
                snapshot.appendItems(self.items.system.sorted(), toSection: .system)
            }
            
            await dataSource.apply(snapshot)
        }
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("sounds", conformingTo: .folder)
            .appendingPathComponent("menu.mp3", conformingTo: .fileURL)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                self.player = try AVAudioPlayer(contentsOf: url)
                guard let player = self.player else {
                    return
                }
                
                player.numberOfLoops = -1
                player.play()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        citra().resetSettings()
        
        guard let section = dataSource.sectionIdentifier(for: indexPath.section) else {
            return
        }
        
        switch section {
        case .imported, .installed:
            guard let game = dataSource.snapshot().itemIdentifiers(inSection: section)[indexPath.row] as? LMInstalledGame else {
                return
            }
            
            let emulationViewController = LMEmulationController(game: game)
            emulationViewController.modalPresentationStyle = .fullScreen
            let vc = self
            present(emulationViewController, animated: true) {
                if let player = vc.player, player.isPlaying {
                    player.stop()
                }
            }
        case .system:
            guard let game = dataSource.snapshot().itemIdentifiers(inSection: section)[indexPath.row] as? LMImportedGame else {
                return
            }
            
            let emulationViewController = LMEmulationController(game: game)
            emulationViewController.modalPresentationStyle = .fullScreen
            let vc = self
            present(emulationViewController, animated: true) {
                if let player = vc.player, player.isPlaying {
                    player.stop()
                }
            }
        }
    }
    
    
    fileprivate func openCIADocumentPicker() {
        let documentPickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: [
            .init("com.nintendo-3ds.cia")!
        ], asCopy: true)
        if let sheetPresentationController = documentPickerViewController.sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
        }
        
        documentPickerViewController.delegate = self
        present(documentPickerViewController, animated: true)
    }
}
