//
//  LMInputBridge.mm
//  emuThreeDS
//
//  Created by Jarrod Norwell on 13/9/2023.
//

#import "LMInputBridge.h"

@implementation ButtonInputBridge {
    ButtonBridge<bool>* _cppBridge;
}

-(ButtonInputBridge *) init {
    if(self = [super init]) {
        _cppBridge = new ButtonBridge<bool>(false);
    } return self;
}

-(void) pressChangedHandler:(GCControllerButtonInput *)input value:(float)value pressed:(BOOL)pressed {
    _cppBridge->current_value = pressed;
}

-(ButtonBridge<bool> *) getCppBridge {
    return _cppBridge;
}
@end


@implementation AnalogInputBridge {
    AnalogBridge* _cppBridge;
}

-(AnalogInputBridge *) init {
    if (self = [super init]) {
        _cppBridge = new AnalogBridge(AnalogBridge::Float2D{0, 0});
    } return self;
}

-(void) valueChangedHandler:(GCControllerDirectionPad *)input x:(float)xValue y:(float)yValue {
    _cppBridge->current_value.exchange(AnalogBridge::Float2D{xValue, yValue});
}

-(AnalogBridge *) getCppBridge {
    return _cppBridge;
}
@end
