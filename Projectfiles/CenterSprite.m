#import "CenterSprite.h"

@implementation CenterSprite

-(id)init{
    if(self=[super init]){
        
        self.model = [AppModel sharedModel];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleCenterSize:) name:kTOGGLE_CENTER_SIZE object:self.model];
        
        self.circle = [CCSprite spriteWithFile:@"center110.png"];
        [self addChild:self.circle];
        self.scale = 0.0f;
    }
    return self;
}

-(void)toggleCenterSize:(id)sender{
    float scale = 1.0f;
    if(!self.model.centerCanAcceptFeatures) scale = 0.9f;
    CCEaseOut *easeout = [CCEaseOut actionWithAction:[CCScaleTo actionWithDuration:0.2f scale:scale] rate:2];
    [self runAction:easeout];
}

@end
