//
//  OnboardingKit.h
//  Limon
//
//  Created by Jarrod Norwell on 10/6/23.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: OBBulletedListItemLinkButton
@interface OBBulletedListItemLinkButton : UIButton
+(OBBulletedListItemLinkButton *) linkButton;
@end

// MARK: OBBulletedList
@interface OBBulletedList : UIView
@end

// MARK: OBButtonTray
@interface OBButtonTray : UIView
-(void) addButton:(UIButton *)arg1;

-(void) addCaptionText:(NSString *)arg1;
-(void) setCaptionText:(NSString *)arg1 style:(long long)arg2;
-(void) setCaptionText:(NSString *)arg1 style:(long long)arg2 learnMoreURL:(NSURL *)arg3;
@end

// MARK: OBBaseWelcomeController
@interface OBBaseWelcomeController : UIViewController
@end

@interface OBWelcomeController : OBBaseWelcomeController
@property (nonatomic, retain) OBBulletedList *bulletedList;
@property (nonatomic, retain) OBButtonTray *buttonTray;

-(OBWelcomeController *) initWithTitle:(NSString *)arg1 detailText:(NSString *)arg2 icon:(UIImage * _Nullable)arg3;

-(void) addBulletedListItemWithTitle:(NSString *)arg1 description:(NSString *)arg2 image:(UIImage * _Nullable)arg3;
-(void) addBulletedListItemWithTitle:(NSString *)arg1 description:(NSString *)arg2 image:(UIImage * _Nullable)arg3 linkButton:(OBBulletedListItemLinkButton * _Nullable)arg4;
-(void) addBulletedListItemWithTitle:(NSString *)arg1 description:(NSString *)arg2 image:(UIImage * _Nullable)arg3 tintColor:(UIColor * _Nullable)arg4;
-(void) addBulletedListItemWithTitle:(NSString *)arg1 description:(NSString *)arg2 image:(UIImage * _Nullable)arg3 tintColor:(UIColor *)arg4
              linkButton:(OBBulletedListItemLinkButton *)arg5;

-(void) _floatButtonTray;
-(void) _inlineButtonTray;

-(void) set_shouldInlineButtontray:(BOOL)arg1;
@end

NS_ASSUME_NONNULL_END
