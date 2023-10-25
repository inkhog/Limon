//
//  LMInputManager.h
//  emuThreeDS
//
//  Created by Jarrod Norwell on 13/9/2023.
//

#include "LMInputFactory.h"

namespace LMInputManager {
enum ButtonType {
    N3DS_BUTTON_A = 700,
    N3DS_BUTTON_B = 701,
    N3DS_BUTTON_X = 702,
    N3DS_BUTTON_Y = 703,
    N3DS_BUTTON_START = 704,
    N3DS_BUTTON_SELECT = 705,
    N3DS_BUTTON_HOME = 706,
    N3DS_BUTTON_ZL = 707,
    N3DS_BUTTON_ZR = 708,
    N3DS_DPAD_UP = 709,
    N3DS_DPAD_DOWN = 710,
    N3DS_DPAD_LEFT = 711,
    N3DS_DPAD_RIGHT = 712,
    N3DS_CIRCLEPAD = 713,
    N3DS_CIRCLEPAD_UP = 714,
    N3DS_CIRCLEPAD_DOWN = 715,
    N3DS_CIRCLEPAD_LEFT = 716,
    N3DS_CIRCLEPAD_RIGHT = 717,
    N3DS_STICK_C = 718,
    N3DS_STICK_C_UP = 719,
    N3DS_STICK_C_DOWN = 720,
    N3DS_STICK_C_LEFT = 771,
    N3DS_STICK_C_RIGHT = 772,
    N3DS_TRIGGER_L = 773,
    N3DS_TRIGGER_R = 774,
    N3DS_BUTTON_DEBUG = 781,
    N3DS_BUTTON_GPIO14 = 782
};

void Init(), Shutdown();

AnalogFactory* AnalogHandler();
ButtonFactory* ButtonHandler();

std::string GenerateButtonParamPackage(int type);
std::string GenerateAnalogButtonParamPackage(int axis, float axis_val);
std::string GenerateAnalogParamPackage(int type);

static std::shared_ptr<ButtonFactory> button;
static std::shared_ptr<AnalogFactory> analog;
};
