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
        self.arrDottedLines = [[NSMutableArray alloc] init];
        self.arrLabels = [[NSMutableArray alloc] init];

        self.model = [AppModel sharedModel];
        self.director = [CCDirector sharedDirector];
        
        CCSprite *bg = [CCSprite spriteWithFile:@"bg.png"];
        bg.position = self.director.screenCenter;
        [self addChild:bg];
        
        CCSprite *logo = [CCSprite spriteWithFile:@"logo.png"];
        logo.position = ccp(132, 38);
        [self addChild:logo];
        
        self.center = [[CenterSprite alloc] init];
        self.center.position = self.director.screenCenter;
        [self addChild:self.center];
        
        self.centerLabel = [CCLabelTTF labelWithString:@"Drag a feature to the circle" fontName:@"Bebas Neue" fontSize:30.0f];
        self.centerLabel.color = ccc3(179, 179, 179);
        self.centerLabel.opacity = 0;
        self.centerLabel.scale = 0;
        self.centerLabel.position = ccp(self.director.screenCenter.x, 216);
        [self addChild:self.centerLabel];
        
        [self addFeatures];
        [self addNotificationObservers];
        
        self.touchEnabled = YES;
        
        // Initializing audio engine
        [CDAudioManager initAsynchronously:kAMM_FxOnly];
        [SimpleAudioEngine sharedEngine];
        
        self.overlay = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
        self.overlay.opacity = 0;
        [self addChild:self.overlay];

        [self startAnimations];
        
        // Background color
		glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	}

	return self;
}

-(void) addNotificationObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCenterText:) name:kTOGGLE_CENTER_SIZE object:self.model];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openCenter:) name:kCENTER_OPEN object:self.model];
}

-(void)openCenter:(id)sender{
    float opacity = 0.0f;
    if(self.model.centerOpen){
        opacity = 0.6f * 255;
    }
    CCFadeTo *fade = [CCFadeTo actionWithDuration:0.2f opacity:opacity];
    CCSequence *seq = [CCSequence actions:fade, nil];
    [self.overlay runAction:seq];
    self.center.zOrder = [self.children count] + 1;
    self.overlay.zOrder = [self.children count];
}

-(void)changeCenterText:(id)sender{
    if(self.model.centerCanAcceptFeatures){
        [self.centerLabel setString:@"Drop to explore"];
    }
    else{
        [self.centerLabel setString:@"Drag a feature to the circle"];
    }
}

-(void) addFeatures{
    
    NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"features" ofType:@"plist"]];
    
    for (NSUInteger i=0; i<[arr count]; i++) {
        BeatsFeatureData *data = [[BeatsFeatureData alloc] initWithData:[arr objectAtIndex:i]];
        BeatsFeature *feature = [[BeatsFeature alloc] initWithData:data];
        feature.position = data.position;
        [self.arrItems addObject:feature];
        
        CCLabelTTF *lbl = [CCLabelTTF labelWithString:data.title fontName:@"Bebas Neue" fontSize:20];
        lbl.position = ccp(data.position.x, data.position.y - 79);
        lbl.color = ccc3(179, 179, 179);
        lbl.opacity = 0;
        [self.arrLabels addObject:lbl];
        [self addChild:lbl];
        
        CCSprite *dottedLines = [CCSprite spriteWithFile:@"dotted.png"];
        dottedLines.position = data.position;
        dottedLines.opacity = 0;
        [self.arrDottedLines addObject:dottedLines];
        [self addChild:dottedLines];
        
        [self addChild:feature];
    }
    
}

-(void)startAnimations{
    
    [self introAnimationElastic:self.center andDelay:-2.5f];
    
    CCFadeIn *fade = [CCFadeIn actionWithDuration:0.2f];
    CCScaleTo *scale = [CCScaleTo actionWithDuration:0.5f scale:1.0f];
    CCEaseElasticOut *scaleEase = [CCEaseElasticOut actionWithAction: scale period:0.8f];
    CCSpawn *spawn = [CCSpawn actions:fade, scaleEase, nil];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:1.5f];
    CCSequence *seq = [CCSequence actions:delay, spawn, nil];
    [self.centerLabel runAction:seq];
    
    NSArray *arrPairs = @[ @[@"2", @"3"], @[@"1", @"4"], @[@"0", @"5"] ];
    
    for(NSUInteger i=0; i<[arrPairs count]; i++){
        int index_A = [[[arrPairs objectAtIndex:i] objectAtIndex:0] intValue];
        int index_B = [[[arrPairs objectAtIndex:i] objectAtIndex:1] intValue];
        
        [self introAnimationElastic:[self.arrItems objectAtIndex: index_A] andDelay:i];
        [self introAnimationElastic:[self.arrItems objectAtIndex: index_B] andDelay:i];
        
        [self introAnimationFadeIn:[self.arrLabels objectAtIndex:index_A] andDelay:i];
        [self introAnimationFadeIn:[self.arrLabels objectAtIndex:index_B] andDelay:i];
        
        [self introAnimationFadeIn:[self.arrDottedLines objectAtIndex:index_A] andDelay:i];
        [self introAnimationFadeIn:[self.arrDottedLines objectAtIndex:index_B] andDelay:i];
    }
}

-(void)introAnimationElastic:(CCNode *)node andDelay:(float)i{
    CCFadeTo *opacity = [CCFadeTo actionWithDuration:.2f opacity:255];
    CCScaleTo *scale = [CCScaleTo actionWithDuration:.6f scale:0.9f];
    CCEaseElasticOut *scaleEase = [CCEaseElasticOut actionWithAction:scale period:0.6f];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:0.5f + (i * 0.2f)];
    CCSequence *seq = [CCSequence actions:delay, opacity, scaleEase, nil];
    [node runAction:seq];
}

-(void)introAnimationFadeIn:(CCNode *)node andDelay:(NSUInteger)i{
    CCFadeTo *opacity = [CCFadeTo actionWithDuration:.2f opacity:255];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:0.8f + (i * 0.2f)];
    CCSequence *seq = [CCSequence actions:delay, opacity, nil];
    [node runAction:seq];
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if([self.model.draggingSprite isKindOfClass:[BeatsFeature class]]){
        UITouch *myTouch = [touches anyObject];
        
        CGPoint location = [myTouch locationInView: [myTouch view]];
        location = [self.director convertToGL:location];
        
        if(self.model.centerCanAcceptFeatures){
            if(ccpLengthSQ(ccpSub(self.center.position, location))<(150*150))
            {
                self.model.centerCanAcceptFeatures = NO;
            }
        }
        else{
            if(ccpLengthSQ(ccpSub(self.center.position, location))>(150*150))
            {
                self.model.centerCanAcceptFeatures = YES;
            }
        }
        
        self.model.draggingSprite.position = [self.director convertToGL:[myTouch locationInView:[myTouch view]]];
    }
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch* myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView: [myTouch view]];
    location = [self.director convertToGL:location];
    
    if(!self.model.centerOpen){
        CGPoint circleCenter;
        float circleRadius = 63;
        for(NSUInteger i=0; i<[self.arrItems count]; i++){
            BeatsFeature *f = [self.arrItems objectAtIndex:i];
            circleCenter = f.position;
            if(ccpLengthSQ(ccpSub(circleCenter, location))<(circleRadius*circleRadius))
            {
                [f stopAllActions];
                CCEaseOut *scaleEaseOut = [CCEaseOut actionWithAction:[CCScaleTo actionWithDuration:0.2f scale:1.0f] rate:2];
                CCEaseOut *moveEaseOut = [CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:0.2f position:location] rate:2];
                [f runAction:scaleEaseOut];
                [f runAction:moveEaseOut];
                self.center.zOrder = [self.children count];
                f.zOrder = [self.children count];
                self.model.draggingSprite = f;
                return;
            }
        }
    }
    
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch* myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView: [myTouch view]];
    location = [self.director convertToGL:location];
    
    [self.model.draggingSprite stopAllActions];
    CCEaseOut *scaleEaseOut = [CCEaseOut actionWithAction:[CCScaleTo actionWithDuration:0.2f scale:0.9f] rate:2];
    [self.model.draggingSprite runAction:scaleEaseOut];
    if([self.model.draggingSprite isKindOfClass:[BeatsFeature class]]){
        CCMoveTo *move = [CCMoveTo actionWithDuration:0.5f position:((BeatsFeature *)self.model.draggingSprite).data.position];
        CCEaseElasticOut *easeMove = [CCEaseElasticOut actionWithAction:move period:1.0f];
        [self.model.draggingSprite runAction:easeMove];
    }
    if(!self.model.centerCanAcceptFeatures){
        self.model.centerOpen = YES;
        self.model.centerCanAcceptFeatures = YES;
    }
    
    CGPoint circleCenter = self.director.screenCenter;
    float circleRadius = 282;
    if(ccpLengthSQ(ccpSub(circleCenter, location)) > (circleRadius*circleRadius)){
        self.model.centerOpen = NO;
    }
    self.model.draggingSprite = nil;
}

@end
