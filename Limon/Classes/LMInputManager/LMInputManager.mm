//
//  LMInputManager.mm
//  emuThreeDS
//
//  Created by Jarrod Norwell on 13/9/2023.
//

#import "LMInputManager.h"

void LMInputManager::Init() {
    analog = std::make_shared<AnalogFactory>();
    button = std::make_shared<ButtonFactory>();
    
    Input::RegisterFactory<Input::AnalogDevice>("gamepad", analog);
    Input::RegisterFactory<Input::ButtonDevice>("gamepad", button);
};

void LMInputManager::Shutdown() {
    Input::UnregisterFactory<Input::AnalogDevice>("gamepad");
    Input::UnregisterFactory<Input::ButtonDevice>("gamepad");
    
    analog.reset();
    button.reset();
};


AnalogFactory* LMInputManager::AnalogHandler() {
    return analog.get();
};

ButtonFactory* LMInputManager::ButtonHandler() {
    return button.get();
};


std::string LMInputManager::GenerateButtonParamPackage(int button) {
    Common::ParamPackage param{
        {"engine", "gamepad"},
        {"code", std::to_string(button)},
    };
    return param.Serialize();
};

std::string LMInputManager::GenerateAnalogButtonParamPackage(int axis, float axis_val) {
    Common::ParamPackage param{
        {"engine", "gamepad"},
        {"axis", std::to_string(axis)},
    };
    if (axis_val > 0) {
        param.Set("direction", "+");
        param.Set("threshold", "0.5");
    } else {
        param.Set("direction", "-");
        param.Set("threshold", "-0.5");
    }

    return param.Serialize();
};

std::string LMInputManager::GenerateAnalogParamPackage(int axis_id) {
    Common::ParamPackage param{
        {"engine", "gamepad"},
        {"code", std::to_string(axis_id)},
    };
    return param.Serialize();
};
