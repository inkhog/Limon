//
//  LMCitra.h
//  Limon
//
//  Created by Jarrod Norwell on 10/9/23.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/CAMetalLayer.h>
#import <UIKit/UIKit.h>

#import "LMGameImporter.h"
#import "LMGameInformation.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMSaveState : NSObject
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *title;

-(LMSaveState *) initWithURL:(NSURL *)url title:(NSString *)title;
@end

@interface LMCitra : NSObject {
    BOOL _isRunning, _isPaused, _isLoading, _isSaving;
    
    uint64_t title_id, movie_id;
    NSString *_path;
    NSURL *_savePath;
    
    CAMetalLayer* _layer;
}

@property (nonatomic, retain) LMGameImporter *gameImporter;
@property (nonatomic, retain) LMGameInformation *gameInformation;

@property (nonatomic) NSUInteger _layoutOption;

+(LMCitra *) sharedInstance NS_SWIFT_NAME(shared());

-(NSMutableArray<NSString *> *) installedGamePaths;
-(NSMutableArray<NSString *> *) systemGamePaths;

-(void) resetSettings;

-(void) setMetalLayer:(CAMetalLayer *)layer;
-(void) setOrientation:(UIDeviceOrientation)orientation with:(CAMetalLayer *)layer;
-(void) setLayoutOption:(NSUInteger)option with:(CAMetalLayer *)layer;
-(void) swapScreens:(CAMetalLayer *)layer;

-(void) insert:(NSString *)path;
-(void) pause;
-(void) resume;
-(void) run;

-(void) touchesBegan:(CGPoint)point NS_SWIFT_NAME(touchesBegan(point:));
-(void) touchesEnded NS_SWIFT_NAME(touchesEnded());
-(void) touchesMoved:(CGPoint)point NS_SWIFT_NAME(touchesMoved(point:));

-(BOOL) isPaused;
-(BOOL) isRunning;

-(void) load:(NSURL *)url;
-(NSMutableArray<LMSaveState *> *) saveStates;

-(void) load;
-(void) save;

-(void) prepareForLoad;
-(void) prepareForSave;
@end

NS_ASSUME_NONNULL_END
