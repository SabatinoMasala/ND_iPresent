#import "LocateResellerOverlay.h"
#import "AppModel.h"

@implementation LocateResellerOverlay

-(id)init{
    if(self = [super init]){
        float w = [CCDirector sharedDirector].screenSize.width;
        self.layer = [CCLayerColor layerWithColor:ccc4(114, 115, 115, 255) width:w height:369];
        self.layer.position = ccp(0, 42);
        self.layer.visible = NO;
        [self addChild:self.layer];
        
        self.button = [CCLayerColor layerWithColor:ccc4(114, 115, 115, 255) width:215 height:42];
        self.button.position = ccp((w / 2) - (215 / 2), 0);
        [self addChild:self.button];
        
        self.lblClose = [CCLabelTTF labelWithString:@"find a reseller" fontName:@"Bebas Neue" fontSize:25];
        self.lblClose.position = ccp(w / 2, 22);
        [self addChild:self.lblClose];
        
        self.touchEnabled = YES;
        
    }
    return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    /*if(![[AppModel sharedModel] centerOpen]){
    
        if([self.button containsTouch:touch]){
            self.layer.visible = YES;
            CCMoveBy *move = [CCMoveBy actionWithDuration:0.7f position:ccp(0, -369)];
            CCEaseExponentialOut *moveEase = [CCEaseExponentialOut actionWithAction:move];
            [self runAction:moveEase];
        }
        
    }*/
}

@end
