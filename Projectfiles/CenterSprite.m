#import "CenterSprite.h"

@implementation CenterSprite

-(id)init{
    if(self=[super init]){
        
        self.model = [AppModel sharedModel];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleCenterSize:) name:kTOGGLE_CENTER_SIZE object:self.model];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openCenter:) name:kSCREEN_STATE_CHANGED object:self.model];
        
        self.fullCircle = [[FullCircle alloc] init];
        self.fullCircle.scale = 0.001f;
        [self addChild:self.fullCircle];
        
        self.smallCircle = [CCSprite spriteWithFile:@"center110.png"];
        [self addChild:self.smallCircle];
        self.scale = 0.001f;
        
    }
    return self;
}

-(void)toggleCenterSize:(id)sender{
    float scale = 0.9f;
    if(self.model.isOverCenter) scale = 1.0f;
    CCEaseOut *easeout = [CCEaseOut actionWithAction:[CCScaleTo actionWithDuration:0.2f scale:scale] rate:2];
    [self runAction:easeout];
}

-(void)openCenter:(id)sender{
    if([self.model.screenState isEqualToString:@"detail"] || ([self.model.screenState isEqualToString:@"home"] && [self.model.prevScreenState isEqualToString:@"detail"]) ){
        if([self.model.screenState isEqualToString:@"detail"]){ // Open up the big circle
            
            [self.fullCircle update:self.model.draggingSprite.data];
            
            CCFadeTo *fade_out = [CCFadeTo actionWithDuration:0.2f opacity:0];
            [self.smallCircle runAction:fade_out];
        
            CCFadeTo *fade_in = [CCFadeTo actionWithDuration:0.2f opacity:255];
            CCScaleTo *scale_100 = [CCScaleTo actionWithDuration:1.0f scale:1.0f];
            CCEaseElasticOut *scale_ease = [CCEaseElasticOut actionWithAction:scale_100 period:0.6f];
            CCSpawn *animation = [CCSpawn actions:fade_in, scale_ease, nil];
            [self.fullCircle runAction:animation];
        }
        else{ // Close the big circle
            
            [self.fullCircle shutDown];
            
            self.smallCircle.scale = 0;
            CCFadeTo *fade_in = [CCFadeTo actionWithDuration:0.2f opacity:255];
            CCScaleTo *scale_to = [CCScaleTo actionWithDuration:1.0f scale:1.0f];
            CCEaseElasticOut *scale_ease_A = [CCEaseElasticOut actionWithAction:scale_to period:0.6f];
            CCSpawn *spawn = [CCSpawn actions:fade_in, scale_ease_A, nil];
            [self.smallCircle runAction:spawn];
            
            CCFadeTo *fade_out = [CCFadeTo actionWithDuration:0.2f opacity:0];
            CCScaleTo *scale_0 = [CCScaleTo actionWithDuration:1.0f scale:0.001f];
            CCEaseElasticOut *scale_ease = [CCEaseElasticOut actionWithAction:scale_0 period:0.6f];
            CCSpawn *animation = [CCSpawn actions:fade_out, scale_ease, nil];
            [self.fullCircle runAction:animation];
        }
    }
}

@end
