//
//  LMGamesController+OutOfGameSettings.swift
//  Limon
//
//  Created by Jarrod Norwell on 11/3/23.
//

import Foundation
import UIKit

extension LMGamesController {
    func reloadInGameSettingsMenu() {
        Task {
            navigationItem.setLeftBarButton(.init(image: .init(systemName: "gearshape.fill"), menu: outOfGameSettingsMenu()), animated: true)
        }
    }
    
    
    fileprivate func coreSubmenu() -> UIMenu {
        func children() -> [UIMenuElement] {
            let cpuClockMenuChildren = [
                (value: 100, systemName: "dial.high.fill"), (value: 75, systemName: "dial.medium.fill"), (value: 50, systemName: "dial.low.fill")
            ]
            
            return [
                UIAction(title: "CPU JIT (\(EmulationSettings.useCPUJIT ? "on" : "off"))", image: .init(systemName: EmulationSettings.useCPUJIT ? "tortoise.fill" : "hare.fill"), handler: { _ in
                    self.settings.set(bool: !EmulationSettings.useCPUJIT, for: "useCPUJIT", self)
                }),
                UIMenu(title: "CPU Clock", image: .init(systemName: EmulationSettings.cpuClockPercentage == 100 ? "dial.high.fill" : EmulationSettings.cpuClockPercentage == 75 ? "dial.medium.fill" : "dial.low.fill"), children: cpuClockMenuChildren.reduce(into: [UIAction](), { partialResult, option in
                    partialResult.append(.init(title: "\(option.value)%", image: .init(systemName: option.systemName), state: EmulationSettings.cpuClockPercentage == option.value ? .on : .off, handler: { _ in
                        self.settings.set(int: option.value, for: "cpuClockPercentage", self)
                    }))
                })),
                UIAction(title: "New 3DS (\(EmulationSettings.isNew3DS ? "new" : "old"))", image: .init(systemName: EmulationSettings.isNew3DS ? "star.slash.fill" : "star.fill"), handler: { _ in
                    self.settings.set(bool: !EmulationSettings.isNew3DS, for: "isNew3DS", self)
                })
            ]
        }
        
        let menu: UIMenu = if #available(iOS 16, *) {
            .init(title: "Core", image: .init(systemName: "cpu.fill"), preferredElementSize: .medium, children: children())
        } else {
            .init(options: .displayInline, children: children())
        }
        
        return menu
    }
    
    fileprivate func audioSubmenu() -> UIMenu {
        func children() -> [UIMenuElement] {
            let audioInputMenuChildren = [
                (title: "Auto", value: 0), (title: "Disabled", value: 1), (title: "Static Noise", value: 2), (title: "OpenAL", value: 3)
            ]
            
            let audioOutputMenuChildren = [
                (title: "Auto", value: 0), (title: "Disabled", value: 1), (title: "OpenAL", value: 2), (title: "SDL2", value: 3)
            ]
            
            return [
                UIMenu(title: "Audio Input", image: .init(systemName: "mic.fill"), children: audioInputMenuChildren.reduce(into: [UIAction](), { partialResult, input in
                    partialResult.append(.init(title: input.title, state: EmulationSettings.audioInputType == input.value ? .on : .off, handler: { _ in
                        self.settings.set(int: input.value, for: "audioInputType", self)
                    }))
                })),
                UIMenu(title: "Audio Output", image: .init(systemName: "speaker.wave.3.fill"), children: audioOutputMenuChildren.reduce(into: [UIAction](), { partialResult, output in
                    partialResult.append(.init(title: output.title, state: EmulationSettings.audioOutputType == output.value ? .on : .off, handler: { _ in
                        self.settings.set(int: output.value, for: "audioOutputType", self)
                    }))
                }))
            ]
        }
        
        let menu: UIMenu = if #available(iOS 16, *) {
            .init(title: "Audio", image: .init(systemName: "speaker.wave.3.fill"), preferredElementSize: .medium, children: children())
        } else {
            .init(options: .displayInline, children: children())
        }
        
        return menu
    }
    
    fileprivate func moreRendererSubmenu() -> UIMenu {
        func children() -> [UIMenuElement] {
            [
                UIMenu(title: "Texture Filter", image: .init(systemName: "camera.filters"), children: TextureFilter.filters.reduce(into: [UIAction](), { partialResult, filter in
                    partialResult.append(.init(title: filter.description, image: .init(systemName: ""), state: EmulationSettings.textureFilter == filter.rawValue ? .on : .off, handler: { _ in
                        self.settings.set(int: filter.rawValue, for: "textureFilter", self)
                    }))
                })),
                UIMenu(title: "Texture Sampling", image: .init(systemName: "camera.filters"), children: TextureSampling.samples.reduce(into: [UIAction](), { partialResult, sample in
                    partialResult.append(.init(title: sample.description, image: .init(systemName: ""), state: EmulationSettings.textureSampling == sample.rawValue ? .on : .off, handler: { _ in
                        self.settings.set(int: sample.rawValue, for: "textureSampling", self)
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
                })),
                UIMenu(title: "Frame Limit", image: .init(systemName: "dial.medium.fill"), children: FrameLimit.limits.reduce(into: [UIAction](), { partialResult, option in
                    partialResult.append(.init(title: option.description, image: .init(systemName: ""), state: EmulationSettings.frameLimit == option.rawValue ? .on : .off, handler: { _ in
                        self.settings.set(int: option.rawValue, for: "frameLimit", self)
                    }))
                }))
            ]
        }
        
        let menu: UIMenu = if #available(iOS 16, *) {
            .init(title: "More", image: .init(systemName: "plus"), preferredElementSize: .medium, children: children())
        } else {
            .init(options: .displayInline, children: children())
        }
        
        return menu
    }
    
    fileprivate func rendererSubmenu() -> UIMenu {
        func children() -> [UIMenuElement] {
            func children() -> [UIMenuElement] {
                [
                    UIMenu(title: "Async", image: .init(systemName: ""), children: [
                        UIAction(title: "Shader Compilation", image: .init(systemName: ""), state: EmulationSettings.asyncShaderCompilation ? .on : .off, handler: { _ in
                            self.settings.set(bool: !EmulationSettings.asyncShaderCompilation, for: "asyncShaderCompilation", self)
                        }),
                        UIAction(title: "Shader Presentation", image: .init(systemName: ""), state: EmulationSettings.asyncShaderPresentation ? .on : .off, handler: { _ in
                            self.settings.set(bool: !EmulationSettings.asyncShaderPresentation, for: "asyncShaderPresentation", self)
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
                    }),
                    UIAction(title: "New VSync", image: .init(systemName: ""), state: EmulationSettings.useNewVSync ? .on : .off, handler: { _ in
                        self.settings.set(bool: !EmulationSettings.useNewVSync, for: "useNewVSync", self)
                    })
                ]
            }
            
            let menu: UIMenu = if #available(iOS 16, *) {
                .init(options: .displayInline, preferredElementSize: .medium, children: [
                    UIMenu(title: "Shaders", image: .init(systemName: "moonphase.first.quarter"), children: children()),
                    moreRendererSubmenu()
                ])
            } else {
                .init(children: [
                    UIMenu(title: "Shaders", image: .init(systemName: "moonphase.first.quarter"), children: children()),
                    moreRendererSubmenu()
                ])
            }
            
            return [menu]
        }
        
        let menu: UIMenu = if #available(iOS 16, *) {
            .init(title: "Renderer", image: .init(systemName: "camera.macro"), children: children())
        } else {
            .init(title: "Renderer", image: .init(systemName: "camera.macro"), children: children())
        }
        
        return menu
    }
    
    func outOfGameSettingsMenu() -> UIMenu {
        .init(children: [coreSubmenu(), audioSubmenu(), rendererSubmenu()])
    }
}
