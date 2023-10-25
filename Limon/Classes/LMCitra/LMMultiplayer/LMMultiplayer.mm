//
//  LMMultiplayer.mm
//  Limon
//
//  Created by Jarrod Norwell on 10/24/23.
//

#import "LMMultiplayer.h"

@interface LMMultiplayer () {
    std::shared_ptr<NetworkRoomMember> roomMember;
}
@end

@implementation LMMultiplayer
+(LMMultiplayer *) sharedInstance {
    static LMMultiplayer *sharedInstance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LMMultiplayer alloc] init];
    });
    return sharedInstance;
}

-(void) directConnect:(NSString *)nickname ipAddress:(NSString *)ipAddress port:(NSString * _Nullable)port password:(NSString * _Nullable)password
   onRoomStateChanged:(void (^)(RoomState))onRoomStateChanged {
    roomMember = Network::GetRoomMember().lock();
    roomMember->BindOnStateChanged([onRoomStateChanged](const Network::RoomMember::State& state) { onRoomStateChanged((RoomState)state); });
    
    NSString *prt = NULL;
    if ([port isEqualToString:@""] || port == NULL)
        prt = @"24872";
    
    if ([password isEqualToString:@""] || password == NULL)
        roomMember->Join([nickname UTF8String], Service::CFG::GetConsoleIdHash(Core::System::GetInstance()), [ipAddress UTF8String],
                         [prt intValue], 0, Network::NoPreferredMac);
    else
        roomMember->Join([nickname UTF8String], Service::CFG::GetConsoleIdHash(Core::System::GetInstance()), [ipAddress UTF8String],
                         [prt intValue], 0, Network::NoPreferredMac, [password UTF8String]);
}
@end
