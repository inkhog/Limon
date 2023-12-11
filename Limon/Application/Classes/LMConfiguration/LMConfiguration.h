//
//  LMConfiguration.h
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

#pragma once

#include <memory>
#include <string>
#include "common/settings.h"

class INIReader;

class LMConfiguration {
private:
    std::unique_ptr<INIReader> sdl2_config;
    std::string sdl2_config_loc;

    bool LoadINI(const std::string& default_contents = "", bool retry = true);
    void ReadValues();
    void UpdateCFG();

public:
    LMConfiguration();
    ~LMConfiguration();

    void Reload();

private:
    /**
     * Applies a value read from the sdl2_config to a Setting.
     *
     * @param group The name of the INI group
     * @param setting The yuzu setting to modify
     */
    template <typename Type, bool ranged>
    void ReadSetting(const std::string& group, Settings::Setting<Type, ranged>& setting);
};
