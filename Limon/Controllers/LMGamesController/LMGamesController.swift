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
    @objc static var asyncPresentation: Bool = UserDefaults.standard.bool(forKey: "asyncPresentation")
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
        EmulationSettings.asyncPresentation = UserDefaults.standard.bool(forKey: "asyncPresentation")
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
            gamesController.navigationItem.setLeftBarButton(.init(image: .init(systemName: "gearshape.fill"), menu: gamesController.settingsMenu()), animated: true)
        }
    }
    
    @objc func set(int: Int, for key: String, _ controller: UIViewController) {
        UserDefaults.standard.set(int, forKey: key)
        
        if let gamesController = controller as? LMGamesController {
            gamesController.settings = .init()
            gamesController.navigationItem.setLeftBarButton(.init(image: .init(systemName: "gearshape.fill"), menu: gamesController.settingsMenu()), animated: true)
        }
    }
}


class LMGamesController : UICollectionViewController {
    fileprivate var items: (imported: [LMInstalledGame], installed: [LMInstalledGame], system: [LMImportedGame])
    
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil
    var snapshot: NSDiffableDataSourceSnapshot<Section, AnyHashable>! = nil
    
    var settings = EmulationSettings()
    
    var player: AVAudioPlayer!
    
    init(_ collectionViewLayout: UICollectionViewLayout, _ items: (imported: [LMInstalledGame], installed: [LMInstalledGame], system: [LMImportedGame])) {
        self.items = items
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setLeftBarButton(.init(image: .init(systemName: "gearshape.fill"), menu: settingsMenu()), animated: true)
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
            
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player.numberOfLoops = -1
            self.player.play()
        } catch {
            print(error.localizedDescription)
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
            present(emulationViewController, animated: true)
        case .system:
            guard let game = dataSource.snapshot().itemIdentifiers(inSection: section)[indexPath.row] as? LMImportedGame else {
                return
            }
            
            let emulationViewController = LMEmulationController(game: game)
            emulationViewController.modalPresentationStyle = .fullScreen
            present(emulationViewController, animated: true)
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
    
    
    fileprivate func settingsMenu() -> UIMenu {
        let cpuClockMenuChildren = [
            (value: 100, systemName: "dial.high.fill"), (value: 75, systemName: "dial.medium.fill"), (value: 50, systemName: "dial.low.fill")
        ]
        
        
        let coreSettingsMenu: UIMenu = if #available(iOS 16, *) {
            .init(options: .displayInline, preferredElementSize: .small, children: [
                UIAction(image: .init(systemName: EmulationSettings.useCPUJIT ? "tortoise.fill" : "hare.fill"), handler: { _ in
                    self.settings.set(bool: !EmulationSettings.useCPUJIT, for: "useCPUJIT", self)
                }),
                UIMenu(title: "CPU Clock", image: .init(systemName: EmulationSettings.cpuClockPercentage == 100 ? "dial.high.fill" : EmulationSettings.cpuClockPercentage == 75 ? "dial.medium.fill" : "dial.low.fill"), children: cpuClockMenuChildren.reduce(into: [UIAction](), { partialResult, option in
                    partialResult.append(.init(title: "\(option.value)%", image: .init(systemName: option.systemName), state: EmulationSettings.cpuClockPercentage == option.value ? .on : .off, handler: { _ in
                        self.settings.set(int: option.value, for: "cpuClockPercentage", self)
                    }))
                })),
                UIAction(image: .init(systemName: EmulationSettings.isNew3DS ? "star.slash.fill" : "star.fill"), handler: { _ in
                    self.settings.set(bool: !EmulationSettings.isNew3DS, for: "isNew3DS", self)
                })
            ])
        } else {
            .init(options: .displayInline, children: [
                UIAction(image: .init(systemName: EmulationSettings.useCPUJIT ? "tortoise.fill" : "hare.fill"), handler: { _ in
                    self.settings.set(bool: !EmulationSettings.useCPUJIT, for: "useCPUJIT", self)
                }),
                UIMenu(title: "CPU Clock", image: .init(systemName: EmulationSettings.cpuClockPercentage == 100 ? "dial.high.fill" : EmulationSettings.cpuClockPercentage == 75 ? "dial.medium.fill" : "dial.low.fill"), children: cpuClockMenuChildren.reduce(into: [UIAction](), { partialResult, option in
                    partialResult.append(.init(title: "\(option.value)%", image: .init(systemName: option.systemName), state: EmulationSettings.cpuClockPercentage == option.value ? .on : .off, handler: { _ in
                        self.settings.set(int: option.value, for: "cpuClockPercentage", self)
                    }))
                })),
                UIAction(image: .init(systemName: EmulationSettings.isNew3DS ? "star.slash.fill" : "star.fill"), handler: { _ in
                    self.settings.set(bool: !EmulationSettings.isNew3DS, for: "isNew3DS", self)
                })
            ])
        }
        
        
        let audioInputMenuChildren = [
            (title: "Auto", value: 0), (title: "Disabled", value: 1), (title: "Static Noise", value: 2), (title: "OpenAL", value: 3)
        ]
        
        let audioOutputMenuChildren = [
            (title: "Auto", value: 0), (title: "Disabled", value: 1), (title: "OpenAL", value: 2), (title: "SDL2", value: 3), (title: "CoreAudio", value: 4)
        ]
        
        let audioSettingsMenu: UIMenu = if #available(iOS 16, *) {
            .init(options: .displayInline, preferredElementSize: .small, children: [
                UIMenu(title: "Audio Input", image: .init(systemName: "mic.fill"), children: audioInputMenuChildren.reduce(into: [UIAction](), { partialResult, input in
                    partialResult.append(.init(title: input.title, state: EmulationSettings.audioInputType == input.value ? .on : .off, handler: { _ in
                        self.settings.set(int: input.value, for: "audioInputType", self)
                    }))
                })),
                UIMenu(title: "Audio Output", image: .init(systemName: "speaker.wave.3.fill"), children: audioOutputMenuChildren.reduce(into: [UIAction](), { partialResult, output in
                    partialResult.append(.init(title: output.title, attributes: output.value == 4 ? [.disabled] : [], state: EmulationSettings.audioOutputType == output.value ? .on : .off, handler: { _ in
                        self.settings.set(int: output.value, for: "audioOutputType", self)
                    }))
                }))
            ])
        } else {
            .init(options: .displayInline, children: [
                UIMenu(title: "Audio Input", image: .init(systemName: "mic.fill"), children: audioInputMenuChildren.reduce(into: [UIAction](), { partialResult, input in
                    partialResult.append(.init(title: input.title, state: EmulationSettings.audioInputType == input.value ? .on : .off, handler: { _ in
                        self.settings.set(int: input.value, for: "audioInputType", self)
                    }))
                })),
                UIMenu(title: "Audio Output", image: .init(systemName: "speaker.wave.3.fill"), children: audioOutputMenuChildren.reduce(into: [UIAction](), { partialResult, output in
                    partialResult.append(.init(title: output.title, attributes: output.value == 4 ? [.disabled] : [], state: EmulationSettings.audioOutputType == output.value ? .on : .off, handler: { _ in
                        self.settings.set(int: output.value, for: "audioOutputType", self)
                    }))
                }))
            ])
        }
        
        let rendererSettings: [UIMenuElement] = [
            UIMenu(title: "Shader", image: .init(systemName: ""), children: [
                UIMenu(title: "Async", image: .init(systemName: ""), children: [
                    UIAction(title: "Shader Compilation", image: .init(systemName: ""), state: EmulationSettings.asyncShaderCompilation ? .on : .off, handler: { _ in
                        self.settings.set(bool: !EmulationSettings.asyncShaderCompilation, for: "asyncShaderCompilation", self)
                    }),
                    UIAction(title: "Shader Presentation", image: .init(systemName: ""), state: EmulationSettings.asyncPresentation ? .on : .off, handler: { _ in
                        self.settings.set(bool: !EmulationSettings.asyncPresentation, for: "asyncShaderPresentation", self)
                    })
                ]),
                UIAction(title: "SPIRV Shader Generation", image: .init(systemName: ""), state: EmulationSettings.spirvShaderGen ? .on : .off, handler: { _ in
                    self.settings.set(bool: !EmulationSettings.spirvShaderGen, for: "spirvShaderGen", self)
                }),
                UIAction(title: "Hardware Shader", image: .init(systemName: ""), state: EmulationSettings.useHWShader ? .on : .off, handler: { _ in
                    self.settings.set(bool: !EmulationSettings.useHWShader, for: "useHWShader", self)
                }),
                UIAction(title: "Disk Shader Cache", image: .init(systemName: ""), state: EmulationSettings.useDiskShaderCache ? .on : .off, handler: { _ in
                    self.settings.set(bool: !EmulationSettings.useDiskShaderCache, for: "useDiskShaderCache", self)
                }),
                UIAction(title: "Shaders Accurate Mul", image: .init(systemName: ""), state: EmulationSettings.shadersAccurateMul ? .on : .off, handler: { _ in
                    self.settings.set(bool: !EmulationSettings.shadersAccurateMul, for: "shadersAccurateMul", self)
                }),
                UIAction(title: "Shader JIT", image: .init(systemName: ""), state: EmulationSettings.useShaderJIT ? .on : .off, handler: { _ in
                    self.settings.set(bool: !EmulationSettings.useShaderJIT, for: "useShaderJIT", self)
                })
            ]),
            UIAction(title: "New VSync", image: .init(systemName: ""), state: EmulationSettings.useNewVSync ? .on : .off, handler: { _ in
                self.settings.set(bool: !EmulationSettings.useNewVSync, for: "useNewVSync", self)
            })
        ]
        
        let divider2 = UIMenu(title: "Renderer", options: .displayInline, children: rendererSettings)
        
        let rendererSettings2: [UIMenuElement] = [
            UIMenu(title: "Texture Filter", image: .init(systemName: "camera.filters"), children: TextureFilter.filters.reduce(into: [UIAction](), { partialResult, filter in
                partialResult.append(.init(title: filter.description, image: .init(systemName: ""), state: EmulationSettings.textureFilter == filter.rawValue ? .on : .off, handler: { _ in
                    self.settings.set(int: filter.rawValue, for: "textureFilter", self)
                }))
            })),
            UIMenu(title: "Mono Render", image: .init(systemName: "circle.grid.2x1.left.filled"), children: MonoRender.options.reduce(into: [UIAction](), { partialResult, option in
                partialResult.append(.init(title: option.description, image: .init(systemName: ""), state: EmulationSettings.monoRender == option.rawValue ? .on : .off, handler: { _ in
                    self.settings.set(int: option.rawValue, for: "monoRender", self)
                }))
            })),
            UIMenu(title: "Stereo Render", image: .init(systemName: "circle.grid.2x1.fill"), children: StereoRender.options.reduce(into: [UIAction](), { partialResult, option in
                partialResult.append(.init(title: option.description, image: .init(systemName: ""), state: EmulationSettings.stereoRender == option.rawValue ? .on : .off, handler: { _ in
                    self.settings.set(int: option.rawValue, for: "stereoRender", self)
                }))
            })),
            UIMenu(title: "Resolution Factor", image: .init(systemName: "square.resize.up"), children: Resolution.resolutions.reduce(into: [UIAction](), { partialResult, option in
                partialResult.append(.init(title: option.description, image: .init(systemName: ""), state: EmulationSettings.resolutionFactor == option.rawValue ? .on : .off, handler: { _ in
                    self.settings.set(int: option.rawValue, for: "resolutionFactor", self)
                }))
            }))
        ]
        
        let rendererSettings2Menu: UIMenu = if #available(iOS 16, *) {
            .init(options: .displayInline, preferredElementSize: .small, children: rendererSettings2)
        } else {
            .init(options: .displayInline, children: rendererSettings2)
        }
        
        return .init(children: [
            UIAction(title: "Import CIA", image: .init(systemName: "arrow.down.doc.fill"), handler: { _ in
                self.openCIADocumentPicker()
            }),
            UIMenu(title: "Settings", image: .init(systemName: "gearshape.fill"), children: [coreSettingsMenu, audioSettingsMenu, divider2, rendererSettings2Menu])
        ])
    }
}
