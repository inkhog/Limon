//
//  LMEmulationWindow_Vulkan.h
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

#include "LMEmulationWindow_Apple.h"

class GraphicsContext_Apple : public Frontend::GraphicsContext {
public:
    explicit GraphicsContext_Apple(std::shared_ptr<Common::DynamicLibrary> driver_library);
    ~GraphicsContext_Apple();

    std::shared_ptr<Common::DynamicLibrary> GetDriverLibrary() override;

private:
    std::shared_ptr<Common::DynamicLibrary> driver_library;
};


class LMEmulationWindow_Vulkan : public EmulationWindow_Apple {
public:
    LMEmulationWindow_Vulkan(CA::MetalLayer* surface, std::shared_ptr<Common::DynamicLibrary> driver_library, bool is_secondary, CGSize size);
    ~LMEmulationWindow_Vulkan();
    
    void PollEvents() override;
    
    void OrientationChanged(bool portrait, CA::MetalLayer* surface);
    
    std::unique_ptr<Frontend::GraphicsContext> CreateSharedContext() const override;
    
private:
    bool CreateWindowSurface() override;
    
    std::shared_ptr<Common::DynamicLibrary> driver_library;
};
