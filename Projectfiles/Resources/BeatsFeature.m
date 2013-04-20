#import "BeatsFeature.h"

@implementation BeatsFeature

-(id)initWithData:(BeatsFeatureData*)data{
    if(self=[super init]){
        self.data = data;
        self.circle = [CCSprite spriteWithFile:@"featureCircle110.png"];
        [self addChild:self.circle];
        self.scale = 0.9f;
        [self addIcon];
    }
    return self;
}

-(void)addIcon{
    self.icon = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@110.png", self.data.icon]];
    [self addChild:self.icon];
}

@end
