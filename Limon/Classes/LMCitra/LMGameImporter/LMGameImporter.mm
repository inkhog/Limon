//
//  LMGameImporter.m
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

#import "LMGameImporter.h"

#include "core/hle/service/am/am.h"

@implementation LMGameImporter
+(LMGameImporter *) sharedInstance {
    static dispatch_once_t onceToken;
    static LMGameImporter *sharedInstance = NULL;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LMGameImporter alloc] init];
    });
    return sharedInstance;
}

-(void) importCIA:(NSURL *)url completion:(void (^)(LMImportStatus))completion {
    Service::AM::InstallStatus status = Service::AM::InstallCIA(std::string([url.path UTF8String]), [&, url](std::size_t received, std::size_t total) {
        if (_delegate && [_delegate respondsToSelector:@selector(importingProgressDidChange:received:total:)])
            [_delegate importingProgressDidChange:url.path received:received total:total];
    });
    
    completion((LMImportStatus)status);
}
@end
