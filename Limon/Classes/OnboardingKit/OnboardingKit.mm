//
//  OnboardingKit.m
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

#import "OnboardingKit.h"


@implementation OBBulletedListItemLinkButton
+(OBBulletedListItemLinkButton *)linkButton {
    return [NSClassFromString(@"OBBulletedListItemLinkButton") linkButton];
}
@end


@implementation OBBulletedList
@end


@implementation OBButtonTray
-(void) addButton:(UIButton *)arg1 {
    [self addButton:arg1];
}

-(void) addCaptionText:(NSString *)arg1 {
    [self addCaptionText:arg1];
}

-(void) setCaptionText:(NSString *)arg1 style:(long long)arg2 {
    [self setCaptionText:arg1 style:arg2];
}

-(void) setCaptionText:(NSString *)arg1 style:(long long)arg2 learnMoreURL:(NSURL *)arg3 {
    [self setCaptionText:arg1 style:arg2 learnMoreURL:arg3];
}
@end


@implementation OBBaseWelcomeController
@end


@implementation OBWelcomeController
-(OBWelcomeController *) initWithTitle:(NSString *)arg1 detailText:(NSString *)arg2 icon:(UIImage * _Nullable)arg3 {
    return [[NSClassFromString(@"OBWelcomeController") alloc] initWithTitle:arg1 detailText:arg2 icon:arg3];
}


-(void) addBulletedListItemWithTitle:(NSString *)arg1 description:(NSString *)arg2 image:(UIImage * _Nullable)arg3 {
    [self addBulletedListItemWithTitle:arg1 description:arg2 image:arg3];
}

-(void) addBulletedListItemWithTitle:(NSString *)arg1 description:(NSString *)arg2 image:(UIImage * _Nullable)arg3 linkButton:(OBBulletedListItemLinkButton * _Nullable)arg4 {
    [self addBulletedListItemWithTitle:arg1 description:arg2 image:arg3 linkButton:arg4];
}

-(void) addBulletedListItemWithTitle:(NSString *)arg1 description:(NSString *)arg2 image:(UIImage * _Nullable)arg3 tintColor:(UIColor * _Nullable)arg4 {
    [self addBulletedListItemWithTitle:arg1 description:arg2 image:arg3 tintColor:arg4];
}

-(void) addBulletedListItemWithTitle:(NSString *)arg1 description:(NSString *)arg2 image:(UIImage * _Nullable)arg3 tintColor:(UIColor *)arg4
                          linkButton:(OBBulletedListItemLinkButton *)arg5 {
    [self addBulletedListItemWithTitle:arg1 description:arg2 image:arg3 tintColor:arg4 linkButton:arg5];
}


-(void) _floatButtonTray {
    [self _floatButtonTray];
}

-(void) _inlineButtonTray {
    [self _inlineButtonTray];
}


-(void) set_shouldInlineButtontray:(BOOL)arg1 {
    [self set_shouldInlineButtontray:arg1];
}
@end
