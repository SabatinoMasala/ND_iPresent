#import "FullCircle.h"

@implementation FullCircle

-(id)init{
    if(self=[super init]){
        self.circle = [CCSprite spriteWithFile:@"middleCircleFull.png"];
        [self addChild:self.circle];
        
        self.lblTitle = [CCLabelTTF labelWithString:@"" fontName:@"Bebas Neue" fontSize:35];
        self.lblTitle.position = ccp(0, 23);
        self.lblTitle.color = ccc3(51, 51, 51);
        [self addChild:self.lblTitle];
        
        self.lblDescription = [CCLabelTTF labelWithString:@"" fontName:@"Futura-CondensedMedium" fontSize:20];
        self.lblDescription.color = ccc3(76, 76, 76);
        self.lblDescription.position = ccp(0, -70);
        [self addChild:self.lblDescription];
        
    }
    return self;
}

-(void)update:(BeatsFeatureData *)data{
    [self.lblTitle setString:data.title];
    [self.lblDescription setString:data.description];
    if(self.image){
        [self.image removeFromParentAndCleanup:YES];
        self.image = nil;
    }
    self.image = [CCSprite spriteWithFile:data.image];
    self.image.position = ccp(0, 180);
    [self addChild:self.image];
}

@end