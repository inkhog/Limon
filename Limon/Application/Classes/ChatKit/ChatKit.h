//
//  ChatKit.h
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CKProgressView : UIProgressView
-(CKProgressView *) initWithProgressViewStyle:(long long)arg1;

-(void) setProgress:(float)arg1;

-(void) setTrackTintColor:(UIColor * _Nullable)arg1;
@end

NS_ASSUME_NONNULL_END
