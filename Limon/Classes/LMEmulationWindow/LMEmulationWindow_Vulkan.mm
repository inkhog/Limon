//
//  LMEmulationWindow_Vulkan.m
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

#import "LMEmulationWindow_Vulkan.h"

GraphicsContext_Apple::GraphicsContext_Apple(std::shared_ptr<Common::DynamicLibrary> driver_library) : driver_library(driver_library) {};

GraphicsContext_Apple::~GraphicsContext_Apple() {};


std::shared_ptr<Common::DynamicLibrary> GraphicsContext_Apple::GetDriverLibrary() {
    return driver_library;
};


LMEmulationWindow_Vulkan::LMEmulationWindow_Vulkan(CA::MetalLayer* surface, std::shared_ptr<Common::DynamicLibrary> driver_library, bool is_secondary, CGSize size) : EmulationWindow_Apple(surface, is_secondary, size), driver_library(driver_library) {
    CreateWindowSurface();
    
    if (core_context = CreateSharedContext(); !core_context)
        return;
    
    OnFramebufferSizeChanged();
};

LMEmulationWindow_Vulkan::~LMEmulationWindow_Vulkan() {};


void LMEmulationWindow_Vulkan::PollEvents() {};


void LMEmulationWindow_Vulkan::OrientationChanged(bool portrait, CA::MetalLayer* surface) {
    is_portrait = portrait;
    
    OnSurfaceChanged(surface);
    OnFramebufferSizeChanged();
};


std::unique_ptr<Frontend::GraphicsContext> LMEmulationWindow_Vulkan::CreateSharedContext() const {
    return std::make_unique<GraphicsContext_Apple>(driver_library);
};


bool LMEmulationWindow_Vulkan::CreateWindowSurface() {
    if (!host_window)
        return true;
    
    window_info.render_surface = host_window;
    window_info.type = Frontend::WindowSystemType::MacOS;
    //window_info.render_surface_scale = [[UIScreen mainScreen] nativeScale];
    
    return true;
};
