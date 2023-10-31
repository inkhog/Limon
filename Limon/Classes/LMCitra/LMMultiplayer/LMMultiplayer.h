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
typedef class Network::RoomMember NetworkRoomMember;
typedef enum Network::RoomMember::State RoomMemberState;
#endif

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RoomState) {
    RSUninitialized,
    RSIdle,
    RSJoining,
    RSJoined,
    RSModerator
};

@interface LMMultiplayer : NSObject
+(LMMultiplayer *) sharedInstance;

-(void) directConnect:(NSString *)nickname ipAddress:(NSString *)ipAddress port:(NSString * _Nullable)port password:(NSString * _Nullable)password
              onError:(void (^)())onError onRoomStateChanged:(void(^)(RoomState))onRoomStateChanged;
@end

NS_ASSUME_NONNULL_END
