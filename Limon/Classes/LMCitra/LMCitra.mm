//
//  LMCitra.m
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

#import "LMCitra.h"
#import "LMEmulationWindow_Vulkan.h"

#include "LMConfiguration.h"
#include "LMInputManager.h"

#ifdef __cplusplus
#include "audio_core/dsp_interface.h"
#include "common/dynamic_library/dynamic_library.h"
#include "common/logging/backend.h"
#include "common/logging/log.h"
#include "core/core.h"
#include "core/loader/loader.h"

#include <dlfcn.h>
#include <memory>
#endif

#import "Limon-Swift.h"
@class EmulationSettings;

Core::System& core{Core::System::GetInstance()};
std::unique_ptr<LMEmulationWindow_Vulkan> window;
std::shared_ptr<Common::DynamicLibrary> vulkan_library;

@implementation LMCitra
-(LMCitra *) init {
    if (self = [super init]) {
        Common::Log::Initialize();
        Common::Log::Start();
        
        _gameImporter = [LMGameImporter sharedInstance];
        _gameInformation = [LMGameInformation sharedInstance];
        
        vulkan_library = std::make_shared<Common::DynamicLibrary>(dlopen("@executable_path/Frameworks/libMoltenVK.dylib", RTLD_NOW));
    } return self;
}

+(LMCitra *) sharedInstance {
    static dispatch_once_t onceToken;
    static LMCitra* sharedInstance = NULL;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LMCitra alloc] init];
    });
    return sharedInstance;
}


-(NSMutableArray<NSString *> *) installedGamePaths {
    NSMutableArray<NSString *> *paths = @[].mutableCopy;
    
    const FileUtil::DirectoryEntryCallable ScanDir = [&paths, &ScanDir](u64*, const std::string& directory, const std::string& virtual_name) {
        std::string path = directory + virtual_name;
        if (FileUtil::IsDirectory(path)) {
            path += '/';
            FileUtil::ForeachDirectoryEntry(nullptr, path, ScanDir);
        } else {
            if (!FileUtil::Exists(path))
                return false;
            auto loader = Loader::GetLoader(path);
            if (loader) {
                bool executable{};
                const Loader::ResultStatus result = loader->IsExecutable(executable);
                if (Loader::ResultStatus::Success == result && executable) {
                    [paths addObject:[NSString stringWithCString:path.c_str() encoding:NSUTF8StringEncoding]];
                }
            }
        }
        return true;
    };
    
    ScanDir(nullptr, "", FileUtil::GetUserPath(FileUtil::UserPath::SDMCDir) + "Nintendo " "3DS/00000000000000000000000000000000/" "00000000000000000000000000000000/title/00040000");
    
    return paths;
}

-(NSMutableArray<NSString *> *) systemGamePaths {
    NSMutableArray<NSString *> *paths = @[].mutableCopy;
    
    const FileUtil::DirectoryEntryCallable ScanDir = [&paths, &ScanDir](u64*, const std::string& directory, const std::string& virtual_name) {
        std::string path = directory + virtual_name;
        if (FileUtil::IsDirectory(path)) {
            path += '/';
            FileUtil::ForeachDirectoryEntry(nullptr, path, ScanDir);
        } else {
            if (!FileUtil::Exists(path))
                return false;
            auto loader = Loader::GetLoader(path);
            if (loader) {
                bool executable{};
                const Loader::ResultStatus result = loader->IsExecutable(executable);
                if (Loader::ResultStatus::Success == result && executable) {
                    [paths addObject:[NSString stringWithCString:path.c_str() encoding:NSUTF8StringEncoding]];
                }
            }
        }
        return true;
    };
    
    ScanDir(nullptr, "", FileUtil::GetUserPath(FileUtil::UserPath::NANDDir) + "00000000000000000000000000000000/title/00040010");
    
    return paths;
}


-(void) resetSettings {
    LMConfiguration{};
    
    for (const auto& service_module : Service::service_module_map) {
        Settings::values.lle_modules.emplace(service_module.name, false);
    }
    
    // InputManager::Init();
    for(int i = 0; i < Settings::NativeButton::NumButtons; i++) {
        Common::ParamPackage param{ { "engine", "ios_gamepad" }, { "code", std::to_string(i) } };
        Settings::values.current_input_profile.buttons[i] = param.Serialize();
    }
    
    for(int i = 0; i < Settings::NativeAnalog::NumAnalogs; i++) {
        Common::ParamPackage param{ { "engine", "ios_gamepad" }, { "code", std::to_string(i) } };
        Settings::values.current_input_profile.analogs[i] = param.Serialize();
    }
    
    Input::RegisterFactory<Input::AnalogDevice>("ios_gamepad", std::make_shared<AnalogFactory>());
    Input::RegisterFactory<Input::ButtonDevice>("ios_gamepad", std::make_shared<ButtonFactory>());
    
    Settings::values.use_cpu_jit.SetValue(EmulationSettings.useCPUJIT);
    Settings::values.cpu_clock_percentage.SetValue([[NSNumber numberWithInteger:EmulationSettings.cpuClockPercentage] intValue]);
    Settings::values.is_new_3ds.SetValue(EmulationSettings.isNew3DS);
    
    Settings::values.spirv_shader_gen.SetValue(EmulationSettings.spirvShaderGen);
    Settings::values.async_shader_compilation.SetValue(EmulationSettings.asyncShaderCompilation);
    Settings::values.async_presentation.SetValue(EmulationSettings.asyncPresentation);
    Settings::values.use_hw_shader.SetValue(EmulationSettings.useHWShader);
    Settings::values.use_disk_shader_cache.SetValue(EmulationSettings.useDiskShaderCache);
    Settings::values.shaders_accurate_mul.SetValue(EmulationSettings.shadersAccurateMul);
    Settings::values.use_vsync_new.SetValue(EmulationSettings.useNewVSync);
    Settings::values.use_shader_jit.SetValue(EmulationSettings.useShaderJIT);
    Settings::values.resolution_factor.SetValue([[NSNumber numberWithInteger:EmulationSettings.resolutionFactor] intValue]);
    Settings::values.frame_limit.SetValue(EmulationSettings.frameLimit);
    Settings::values.texture_filter.SetValue((Settings::TextureFilter)EmulationSettings.textureFilter);
    
    Settings::values.render_3d.SetValue((Settings::StereoRenderOption)EmulationSettings.stereoRender);
    Settings::values.factor_3d.SetValue([[NSNumber numberWithInteger:EmulationSettings.factor3D] intValue]);
    Settings::values.mono_render_option.SetValue((Settings::MonoRenderOption)EmulationSettings.monoRender);
    
    Settings::values.input_type.SetValue((AudioCore::InputType)[[NSNumber numberWithInteger:EmulationSettings.audioInputType] intValue]);
    Settings::values.output_type.SetValue((AudioCore::SinkType)[[NSNumber numberWithInteger:EmulationSettings.audioOutputType] intValue]);
    
    core.ApplySettings();
    Settings::LogSettings();
}


-(void) setMetalLayer:(CAMetalLayer *)layer {
    window = std::make_unique<LMEmulationWindow_Vulkan>((__bridge CA::MetalLayer*)layer, vulkan_library, false, layer.frame.size);
    [self setOrientation:[[UIDevice currentDevice] orientation] with:layer];
}

-(void) setOrientation:(UIDeviceOrientation)orientation with:(CAMetalLayer *)layer {
    if (_isRunning && !_isPaused) {
        window->OrientationChanged(orientation == UIDeviceOrientationPortrait, (__bridge CA::MetalLayer*)layer);
    }
}

-(void) setLayoutOption:(NSUInteger)option with:(CAMetalLayer *)layer {
    self._layoutOption = option;
    
    Settings::values.layout_option.SetValue((Settings::LayoutOption)[[NSNumber numberWithInteger:self._layoutOption] intValue]);
    [self setOrientation:[[UIDevice currentDevice] orientation] with:layer];
}

-(void) swapScreens:(CAMetalLayer *)layer {
    Settings::values.swap_screen.SetValue(Settings::values.swap_screen.GetValue() ? false : true);
    [self setOrientation:[[UIDevice currentDevice] orientation] with:layer];
}


-(void) insert:(NSString *)path {
    _path = path;
    FileUtil::SetCurrentRomPath(std::string([_path UTF8String]));
    auto loader = Loader::GetLoader(std::string([_path UTF8String]));
    if(loader)
        loader->ReadProgramId(title_id);
}

-(void) pause {
    _isPaused = TRUE;
}

-(void) resume {
    _isPaused = FALSE;
}

-(void) run {
    window->MakeCurrent();
    core.Load(*window, std::string([_path UTF8String]));
    
    Core::TimingEventType* audio_stretching_event{};
    const s64 audio_stretching_ticks{msToCycles(500)};
    audio_stretching_event =
    core.CoreTiming().RegisterEvent("AudioStretchingEvent", [&](u64, s64 cycles_late) {
        if (Settings::values.enable_audio_stretching) {
            core.DSP().EnableStretching(core.GetAndResetPerfStats().emulation_speed < 0.95);
        }
        
        core.CoreTiming().ScheduleEvent(audio_stretching_ticks - cycles_late,
                                          audio_stretching_event);
    });
    core.CoreTiming().ScheduleEvent(audio_stretching_ticks, audio_stretching_event);
    
    
    _isRunning = TRUE;
    _isPaused = FALSE;
    
    while (_isRunning) {
        if (!_isPaused) {
            if (Settings::values.volume.GetValue() == 0)
                Settings::values.volume.SetValue(1);
            
            core.RunLoop();
        } else {
            if (Settings::values.volume.GetValue() == 1)
                Settings::values.volume.SetValue(0);
        }
    }
}

-(void) stop {
    
}


-(void) touchesBegan:(CGPoint)point {
    window->OnTouchEvent((point.x/* * [[UIScreen mainScreen] nativeScale]*/) + 0.5, (point.y/* * [[UIScreen mainScreen] nativeScale]*/) + 0.5);
}

-(void) touchesEnded {
    window->OnTouchReleased();
}

-(void) touchesMoved:(CGPoint)point {
    window->OnTouchMoved((point.x/* * [[UIScreen mainScreen] nativeScale]*/) + 0.5, (point.y/* * [[UIScreen mainScreen] nativeScale]*/) + 0.5);
}

-(BOOL) isPaused {
    return _isPaused;
}

-(BOOL) isRunning {
    return _isRunning;
}
@end
