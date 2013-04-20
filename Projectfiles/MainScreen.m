#import "MainScreen.h"
#import "SimpleAudioEngine.h"
#import "BeatsFeatureData.h"

@interface MainScreen (PrivateMethods)
@end

@implementation MainScreen

-(id) init
{
	if ((self = [super init]))
	{
        
        self.arrItems = [[NSMutableArray alloc] init];
		
		CCDirector* director = [CCDirector sharedDirector];
        
        CCSprite *bg = [CCSprite spriteWithFile:@"bg.png"];
        bg.position = director.screenCenter;
        [self addChild:bg];
        
        self.center = [CCSprite spriteWithFile:@"center110pct.png"];
        self.center.scale = .9;
        self.center.position = director.screenCenter;
        [self addChild:self.center];
        
        [self addFeatures];
        
        self.touchEnabled = YES;

        // Background color
		glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	}

	return self;
}

-(void) addFeatures{
    
    NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"features" ofType:@"plist"]];
    NSLog(@"%@", arr);
    
    for (NSUInteger i=0; i<[arr count]; i++) {
        BeatsFeatureData *data = [[BeatsFeatureData alloc] initWithData:[arr objectAtIndex:i]];
        BeatsFeature *feature = [[BeatsFeature alloc] initWithData:data];
        feature.position = data.position;
        [self.arrItems addObject:feature];
        [self addChild:feature];
    }
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if([self.touchedSprite isKindOfClass:[BeatsFeature class]]){
        UITouch *myTouch = [touches anyObject];
        self.touchedSprite.position = [[CCDirector sharedDirector] convertToGL:[myTouch locationInView:[myTouch view]]];
    }
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch* myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView: [myTouch view]];
    location = [[CCDirector sharedDirector]convertToGL:location];
    
    CGPoint circleCenter;
    float circleRadius = 63;
    for(NSUInteger i=0; i<[self.arrItems count]; i++){
        BeatsFeature *f = [self.arrItems objectAtIndex:i];
        circleCenter = f.position;
        if(ccpLengthSQ(ccpSub(circleCenter, location))<(circleRadius*circleRadius))
        {
            [f stopAllActions];
            CCEaseOut *easeout = [CCEaseOut actionWithAction:[CCScaleTo actionWithDuration:0.2f scale:1.0f] rate:2];
            [f runAction:easeout];
            self.touchedSprite = f;
            return;
        }
    }
        
    circleCenter = self.center.position;
    circleRadius = 122;
    if(ccpLengthSQ(ccpSub(circleCenter, location))<(circleRadius*circleRadius))
    {
        CCEaseOut *easeout = [CCEaseOut actionWithAction:[CCScaleTo actionWithDuration:0.2f scale:1.0f] rate:2];
        [self.center runAction:easeout];
        self.touchedSprite = self.center;
        return;
    }
    
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CCEaseOut *easeout = [CCEaseOut actionWithAction:[CCScaleTo actionWithDuration:0.2f scale:0.9f] rate:2];
    [self.touchedSprite runAction:easeout];
    if([self.touchedSprite isKindOfClass:[BeatsFeature class]]){
        CCMoveTo *move = [CCMoveTo actionWithDuration:0.5f position:((BeatsFeature *)self.touchedSprite).data.position];
        CCEaseElasticOut *easeMove = [CCEaseElasticOut actionWithAction:move period:1.0f];
        [self.touchedSprite runAction:easeMove];
    }
    self.touchedSprite = nil;
}

@end
