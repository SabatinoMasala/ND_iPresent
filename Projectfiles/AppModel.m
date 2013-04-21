#import "AppModel.h"
#import "SimpleAudioEngine.h"

@implementation AppModel

NSString * const kTOGGLE_CENTER_SIZE = @"TOGGLE_CENTER_SIZE";
NSString * const kSCREEN_STATE_CHANGED = @"SCREEN_STATE_CHANGED";

/* Singleton code */

static AppModel *instance;
+(id) sharedModel{
    if(!instance){
        instance = [[AppModel alloc] init];
    }
    return instance;
}

/* --------------------------------------------- */

-(id) init{
    if(self = [super init]){
        _isOverCenter = NO;
        _screenState = @"home";
    }
    return self;
}

-(void)setScreenState:(NSString *)screenState{
    if(![_screenState isEqualToString:screenState]){
        self.prevScreenState = _screenState;
        _screenState = screenState;
        [[NSNotificationCenter defaultCenter] postNotificationName:kSCREEN_STATE_CHANGED object:self];
    }
}

-(void)setDraggingSprite:(BeatsFeature *)draggingSprite{
    if(draggingSprite != _draggingSprite){
        if(draggingSprite) [[SimpleAudioEngine sharedEngine] playEffect:@"click_2.caf" pitch:1.0f pan:0 gain:0.2f];
        _draggingSprite = draggingSprite;
    }
}

-(void)setIsOverCenter:(BOOL)isOverCenter{
    if(isOverCenter != _isOverCenter){
        if(!isOverCenter) [[SimpleAudioEngine sharedEngine] playEffect:@"click_1.caf" pitch:1.0f pan:0 gain:0.3f];
        _isOverCenter = isOverCenter;
        [[NSNotificationCenter defaultCenter] postNotificationName:kTOGGLE_CENTER_SIZE object:self];
    }
}

@end
