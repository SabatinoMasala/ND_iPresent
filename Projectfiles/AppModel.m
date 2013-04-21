#import "AppModel.h"
#import "SimpleAudioEngine.h"

@implementation AppModel

NSString * const kTOGGLE_CENTER_SIZE = @"TOGGLE_CENTER_SIZE";
NSString * const kCENTER_OPEN = @"CENTER_OPEN";

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
        _centerCanAcceptFeatures = YES;
        _centerOpen = NO;
    }
    return self;
}

-(void)setCenterOpen:(BOOL)centerOpen{
    if(centerOpen != _centerOpen){
        _centerOpen = centerOpen;
        [[NSNotificationCenter defaultCenter] postNotificationName:kCENTER_OPEN object:self];
    }
}

-(void)setDraggingSprite:(BeatsFeature *)draggingSprite{
    if(draggingSprite != _draggingSprite){
        if(draggingSprite) [[SimpleAudioEngine sharedEngine] playEffect:@"click_2.caf" pitch:1.0f pan:0 gain:0.2f];
        _draggingSprite = draggingSprite;
    }
}

-(void)setCenterCanAcceptFeatures:(BOOL)centerCanAcceptFeatures{
    if(centerCanAcceptFeatures != _centerCanAcceptFeatures){
        if(!centerCanAcceptFeatures) [[SimpleAudioEngine sharedEngine] playEffect:@"click_1.caf" pitch:1.0f pan:0 gain:0.3f];
        [[NSNotificationCenter defaultCenter] postNotificationName:kTOGGLE_CENTER_SIZE object:self];
        _centerCanAcceptFeatures = centerCanAcceptFeatures;
    }
}

@end
