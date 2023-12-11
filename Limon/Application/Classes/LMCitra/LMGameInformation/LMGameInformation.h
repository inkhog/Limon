//
//  LMGameInformation.h
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
#include <cstdint>
#include <string>
#include <vector>

#include "core/hle/service/am/am.h"
#include "core/hle/service/fs/archive.h"
#include "core/loader/loader.h"
#include "core/loader/smdh.h"

namespace GameInformation {
std::vector<uint8_t> SMDHData(std::string physical_name);

std::u16string Publisher(std::string physical_name);
std::string Regions(std::string physical_name);
std::u16string Title(std::string physical_name);

std::vector<uint16_t> Icon(std::string physical_name);
}
#endif

NS_ASSUME_NONNULL_BEGIN

@interface LMGameInformation : NSObject
+(LMGameInformation *) sharedInstance NS_SWIFT_NAME(shared());

-(uint16_t*) icon:(NSString *)path NS_SWIFT_NAME(icon(path:));
-(NSString *) publisher:(NSString *)path NS_SWIFT_NAME(publisher(path:));
-(NSString *) regions:(NSString *)path NS_SWIFT_NAME(regions(path:));
-(NSString *) title:(NSString *)path NS_SWIFT_NAME(title(path:));
@end

NS_ASSUME_NONNULL_END
