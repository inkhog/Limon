//
//  ChatKit.m
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

#import "ChatKit.h"

@implementation CKProgressView
-(CKProgressView *) initWithProgressViewStyle:(long long)arg1 {
    return [[NSClassFromString(@"CKProgressView") alloc] initWithProgressViewStyle:arg1];
}


-(void) setProgress:(float)arg1 {
    [self setProgress:arg1];
}


-(void) setTrackTintColor:(UIColor *)arg1 {
    [self setTrackTintColor:arg1];
}
@end
