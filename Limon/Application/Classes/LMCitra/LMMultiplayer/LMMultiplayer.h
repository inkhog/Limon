//
//  LMMultiplayer.h
//  Limon
//
//  Created by Jarrod Norwell on 10/24/23.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
#include "common/announce_multiplayer_room.h"
#include "core/core.h"
#include "core/hle/service/cfg/cfg.h"
#include "network/announce_multiplayer_session.h"
#include "network/network.h"

#include <memory>

typedef struct AnnounceMultiplayerRoom::Room MultiplayerRoom;
typedef struct AnnounceMultiplayerRoom::Room::Member MultiplayerRoomMember;

typedef struct Network::Room NetworkRoom;
typedef enum Network::RoomMember::Error NetworkRoomMemberError;
typedef class Network::RoomMember NetworkRoomMember;
typedef enum Network::RoomMember::State NetworkRoomMemberState;
#endif

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RoomError) {
    lostConnection,
    hostKicked,
    
    unknownError,
    nameCollision,
    macCollision,
    consoleIdCollision,
    wrongVersion,
    wrongPassword,
    couldNotConnect,
    roomIsFull,
    hostBanned,
    
    permissionDenied,
    noSuchUser
};

typedef NS_ENUM(NSUInteger, RoomState) {
    uninitialized,
    idle,
    joining,
    joined,
    moderator
};

@interface LMMultiplayer : NSObject
@property (nonatomic, assign) BOOL connected;

+(LMMultiplayer *) sharedInstance;

-(void) directConnect:(NSString *)nickname ipAddress:(NSString *)ipAddress port:(NSString * _Nullable)port password:(NSString * _Nullable)password
              onError:(void (^)(RoomError))onError onRoomStateChanged:(void(^)(RoomState))onRoomStateChanged;
-(void) leave;
@end

NS_ASSUME_NONNULL_END
