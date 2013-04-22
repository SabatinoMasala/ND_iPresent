#import "LocateResellerOverlay.h"
#import "AppModel.h"

@implementation LocateResellerOverlay

-(id)init{
    if(self = [super init]){
        
        self.model = [AppModel sharedModel];
        
        float w = [CCDirector sharedDirector].screenSize.width;
        self.layer = [CCLayerColor layerWithColor:ccc4(114, 115, 115, 255) width:w height:369];
        self.layer.position = ccp(0, 42);
        self.layer.visible = NO;
        [self addChild:self.layer];
        
        self.mapPlaceholder = [CCLayerColor layerWithColor:ccc4(240, 235, 212, 255) width:604 height:337];
        self.mapPlaceholder.position = ccp(16, 58);
        [self addChild:self.mapPlaceholder];
        
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

-(void)addMapkit{
    NSLog(@"add mapkit");
    UIView *view = [CCDirector sharedDirector].view.superview;
    
    if(!self.map){
        self.map = [[MKMapView alloc] initWithFrame:CGRectMake(15, 15, 605, 338)];
    }
    
//    self.map.opaque = NO;
//    self.map.alpha = 0;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1];
//    self.map.alpha = 1.0;
//    [UIView commitAnimations];
    [view addSubview:self.map];
}

-(void)removeMapkit{
    NSLog(@"removing mapkit");
    [self.map removeFromSuperview];
    self.map = nil;
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    if([self.model.screenState isEqualToString:@"home"]){
        
        if([self.button containsTouch:touch]){
            self.model.screenState = @"locator";
        }
        
    }
    
    else if([self.model.screenState isEqualToString:@"locator"]){
        if(![self.layer containsTouch:touch]){
            self.model.screenState = @"home";
        }
    }
}

@end
