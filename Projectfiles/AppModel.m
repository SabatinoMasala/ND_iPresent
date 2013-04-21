#import "AppModel.h"
#import "SimpleAudioEngine.h"

@implementation AppModel

NSString * const kTOGGLE_CENTER_SIZE = @"TOGGLE_CENTER_SIZE";

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
    }
    return self;
}

-(void)setDraggingSprite:(CCSprite *)draggingSprite{
    if(draggingSprite) [[SimpleAudioEngine sharedEngine] playEffect:@"click_2.caf" pitch:1.0f pan:0 gain:0.2f];
    _draggingSprite = draggingSprite;
}

-(void)setCenterCanAcceptFeatures:(BOOL)centerCanAcceptFeatures{
    if(!centerCanAcceptFeatures) [[SimpleAudioEngine sharedEngine] playEffect:@"click_1.caf" pitch:1.0f pan:0 gain:0.3f];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTOGGLE_CENTER_SIZE object:self];
    _centerCanAcceptFeatures = centerCanAcceptFeatures;
}

@end
