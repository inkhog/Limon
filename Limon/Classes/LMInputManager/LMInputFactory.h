//
//  LMInputFactory.h
//  emuThreeDS
//
//  Created by Jarrod Norwell on 13/9/2023.
//

#ifdef __cplusplus
#include "common/assert.h"
#include "common/settings.h"
#include "core/frontend/input.h"
#include "input_common/main.h"

class AnalogFactory : public Input::Factory<Input::AnalogDevice> {
    std::unique_ptr<Input::InputDevice<std::tuple<float, float>>> Create(const Common::ParamPackage &) override;
};

class ButtonFactory : public Input::Factory<Input::ButtonDevice> {
    std::unique_ptr<Input::InputDevice<bool>> Create(const Common::ParamPackage &) override;
};
#endif
