//
//  LMGameImporter.h
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LMImportStatus) {
    LMImportStatusSuccess,
    LMImportStatusErrorFailedToOpenFile,
    LMImportStatusErrorFileNotFound,
    LMImportStatusErrorAborted,
    LMImportStatusErrorInvalid,
    LMImportStatusErrorEncrypted
};

@protocol LMImportingProgressDelegate <NSObject>
@optional
-(void) importingProgressDidChange:(NSString *)path received:(CGFloat)received total:(CGFloat)total;
@end

@interface LMGameImporter : NSObject
@property (nonatomic, assign, nullable) id<LMImportingProgressDelegate> delegate;

+(LMGameImporter *) sharedInstance NS_SWIFT_NAME(shared());

-(void) importCIA:(NSURL *)url completion:(void(^)(LMImportStatus))completion NS_SWIFT_NAME(importCIA(from:result:));
@end

NS_ASSUME_NONNULL_END
