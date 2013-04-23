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
     
        // Initialize, initialize!
        self.arrItems = [[NSMutableArray alloc] init];
        self.arrLabels = [[NSMutableArray alloc] init];
        
        self.model = [AppModel sharedModel];
        self.director = [CCDirector sharedDirector];
        
        [self addNotificationObservers];
        self.touchEnabled = YES;
        
        
        // Background
        CCSprite *bg = [CCSprite spriteWithFile:@"bg.png"];
        bg.position = self.director.screenCenter;
        [self addChild:bg];
        
        self.dotted = [CCSprite spriteWithFile:@"dotted.png"];
        self.dotted.visible = NO;
        [self addChild:self.dotted];
        
        // Logo in bottom left
        CCSprite *logo = [CCSprite spriteWithFile:@"logo.png"];
        logo.position = ccp(132, 38);
        [self addChild:logo];
        
        // Center sprite
        self.center = [[CenterSprite alloc] init];
        self.center.position = self.director.screenCenter;
        [self addChild:self.center];
        
        // Label under the center sprite
        self.centerLabel = [CCLabelTTF labelWithString:@"Drag a feature to the circle" fontName:@"Bebas Neue" fontSize:30.0f];
        self.centerLabel.color = ccc3(179, 179, 179);
        self.centerLabel.opacity = 0;
        self.centerLabel.scale = 0;
        self.centerLabel.position = ccp(self.director.screenCenter.x, 216);
        [self addChild:self.centerLabel];
        
        // Create the feature circles
        [self addFeatures];
        
        // Create the reseller overlay
        self.locateResellerOverlay = [[LocateResellerOverlay alloc] init];
        self.locateResellerOverlay.position = ccp(0, 768);
        [self addChild:self.locateResellerOverlay];
        
        // Initializing audio engine
        [CDAudioManager initAsynchronously:kAMM_FxOnly];
        [SimpleAudioEngine sharedEngine];
        
        // Create a black overlay CCLayerColor
        self.overlay = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
        self.overlay.opacity = 0;
        [self addChild:self.overlay];
        
        [self startAnimations];
        
        // Background color
		glClearColor(0.0f, 0.0f, 0.0f, 0.0f);

        
}

	return self;
}

// Notifications!
-(void) addNotificationObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCenterText:) name:kTOGGLE_CENTER_SIZE object:self.model];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenChanged:) name:kSCREEN_STATE_CHANGED object:self.model];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appStateChanged:) name:@"APP_STATE_CHANGED" object:self.model];
}

// Background or foreground?
-(void)appStateChanged:(id)sender{
    
    // We're going into the background
    if([self.model.appState isEqualToString:@"background"]){
        // We remove mapview to prevent it going to fullscreen
        if([self.model.screenState isEqualToString:@"locator"]){
            [self.locateResellerOverlay removeMapkit];
        }
        // If we're dragging & press the home button, we should update
        if(self.model.draggingSprite){
            [self ccTouchesEnded:nil withEvent:nil];
        }
    }
    
    // We're coming back
    if([self.model.appState isEqualToString:@"active"]){
        // We add mapview back after a small delay to prevent it from going fullscreen
        if([self.model.screenState isEqualToString:@"locator"]){
            CCCallBlock *block = [CCCallBlock actionWithBlock:^{
                [self.locateResellerOverlay addMapkit];
            }];
            CCDelayTime *delay = [CCDelayTime actionWithDuration:0.1f];
            CCSequence *seq = [CCSequence actions:delay, block, nil];
            [self runAction:seq];
        }
    }
}

// Screen changed
-(void)screenChanged:(id)sender{
    // Are we on the detail state or did we get back to the home state from the detail state?
    if( [self.model.screenState isEqualToString:@"detail"] || ([self.model.screenState isEqualToString:@"home"] && [self.model.prevScreenState isEqualToString:@"detail"]) ){
        if([self.model.screenState isEqualToString:@"detail"]){
            [self showOverlay:YES];
        }
        else{
            [self showOverlay:NO];
        }
        self.center.zOrder = [self.children count] + 1;
        self.overlay.zOrder = [self.children count];
    }
    
    // Are we on the locator state?
    if( [self.model.screenState isEqualToString:@"locator"] ){
        [self showOverlay:YES];
        self.center.zOrder = [self.children count];
        self.overlay.zOrder = [self.children count];
        self.locateResellerOverlay.zOrder = [self.children count];
        [self.locateResellerOverlay stopAllActions];
        CCMoveTo *moveTo = [CCMoveTo actionWithDuration:1.0f position:ccp(0, 357)];
        CCEaseExponentialOut *easeMove = [CCEaseExponentialOut actionWithAction:moveTo];
        CCCallBlock *end = [CCCallBlock actionWithBlock:^{
            [self.locateResellerOverlay addMapkit];
        }];
        self.locateResellerOverlay.layer.visible = YES;
        CCSequence *seq = [CCSequence actions:easeMove, end, nil];
        [self.locateResellerOverlay runAction:seq];
    }
    
    // Did we return to the home state from the locator state?
    if([self.model.screenState isEqualToString:@"home"] && [self.model.prevScreenState isEqualToString:@"locator"]){
        [self.locateResellerOverlay removeMapkit];
        [self showOverlay:NO];
        [self.locateResellerOverlay stopAllActions];
        CCMoveTo *moveTo = [CCMoveTo actionWithDuration:1.0f position:ccp(0, 726)];
        CCEaseExponentialOut *easeMove = [CCEaseExponentialOut actionWithAction:moveTo];
        CCCallBlock *block = [CCCallBlock actionWithBlock:^{
            self.locateResellerOverlay.layer.visible = NO;
        }];
        CCSequence *seq = [CCSequence actions:easeMove, block, nil];
        [self.locateResellerOverlay runAction:seq];
    }
}

-(void)showOverlay:(BOOL)visible {
    float opacity = 0.0f;
    if(visible){
        opacity = 0.6f * 255;
    }
    CCFadeTo *fade = [CCFadeTo actionWithDuration:0.2f opacity:opacity];
    [self.overlay runAction:fade];
}

// Are we hovering over the center or not?
-(void)changeCenterText:(id)sender{
    if(self.model.isOverCenter){
        [self.centerLabel setString:@"Drop to explore"];
    }
    else{
        [self.centerLabel setString:@"Drag a feature to the circle"];
    }
}

-(void) addFeatures{
    
    // Let's make an array with the content of our data plist
    NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"features" ofType:@"plist"]];
    
    // Loop over each feature item
    for (NSUInteger i=0; i<[arr count]; i++) {
        
        // Make data objects, create the feature and position it
        BeatsFeatureData *data = [[BeatsFeatureData alloc] initWithData:[arr objectAtIndex:i]];
        BeatsFeature *feature = [[BeatsFeature alloc] initWithData:data];
        feature.position = data.position;
        [self.arrItems addObject:feature];
        
        // Create the textlabel under the feature
        CCLabelTTF *lbl = [CCLabelTTF labelWithString:data.title fontName:@"Bebas Neue" fontSize:20];
        lbl.position = ccp(data.position.x, data.position.y - 79);
        lbl.color = ccc3(179, 179, 179);
        lbl.opacity = 0;
        [self.arrLabels addObject:lbl];
        [self addChild:lbl];
        
        [self addChild:feature];
    }
    
}

-(void)startAnimations{
    
    // The center circle will appear first
    [self introAnimationElastic:self.center andDelay:-2.5f];
    
    // The centerlabel has slightly different behaviour, so we do that here
    CCFadeIn *fade = [CCFadeIn actionWithDuration:0.2f];
    CCScaleTo *scale = [CCScaleTo actionWithDuration:0.5f scale:1.0f];
    CCEaseElasticOut *scaleEase = [CCEaseElasticOut actionWithAction: scale period:0.8f];
    CCSpawn *spawn = [CCSpawn actions:fade, scaleEase, nil];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:1.5f];
    CCSequence *seq = [CCSequence actions:delay, spawn, nil];
    [self.centerLabel runAction:seq];
    
    // The button at the top slides in
    CCMoveTo *moveTo = [CCMoveTo actionWithDuration:1.2f position:ccp(0, 726)];
    CCDelayTime *delay2 = [CCDelayTime actionWithDuration:1.5f];
    CCEaseExponentialOut *easeMoveTo = [CCEaseExponentialOut actionWithAction:moveTo];
    CCSequence *seq2 = [CCSequence actions:delay2, easeMoveTo, nil];
    [self.locateResellerOverlay runAction:seq2];
    
    // Declare the order in which the features appear
    NSArray *arrPairs = @[ @[@"2", @"3"], @[@"1", @"4"], @[@"0", @"5"] ];
    
    // Loop over that order
    for(NSUInteger i=0; i<[arrPairs count]; i++){
        
        // Get the 2 indices
        int index_A = [[[arrPairs objectAtIndex:i] objectAtIndex:0] intValue];
        int index_B = [[[arrPairs objectAtIndex:i] objectAtIndex:1] intValue];
        
        // Animate the 2 features
        [self introAnimationElastic:[self.arrItems objectAtIndex: index_A] andDelay:i];
        [self introAnimationElastic:[self.arrItems objectAtIndex: index_B] andDelay:i];
        
        // Animate the 2 textlabels of the features
        [self introAnimationFadeIn:[self.arrLabels objectAtIndex:index_A] andDelay:i];
        [self introAnimationFadeIn:[self.arrLabels objectAtIndex:index_B] andDelay:i];
        
    }
}

// For every object that animates with an elastic ease at the beginning
-(void)introAnimationElastic:(CCNode *)node andDelay:(float)i{
    CCFadeTo *opacity = [CCFadeTo actionWithDuration:.2f opacity:255];
    CCScaleTo *scale = [CCScaleTo actionWithDuration:.6f scale:0.9f];
    CCEaseElasticOut *scaleEase = [CCEaseElasticOut actionWithAction:scale period:0.6f];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:0.5f + (i * 0.2f)];
    CCSequence *seq = [CCSequence actions:delay, opacity, scaleEase, nil];
    [node runAction:seq];
}

// For every object that fades in at the beginning
-(void)introAnimationFadeIn:(CCNode *)node andDelay:(NSUInteger)i{
    CCFadeTo *opacity = [CCFadeTo actionWithDuration:.2f opacity:255];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:0.8f + (i * 0.2f)];
    CCSequence *seq = [CCSequence actions:delay, opacity, nil];
    [node runAction:seq];
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // Typechecking on the current dragging object
    if([self.model.draggingSprite isKindOfClass:[BeatsFeature class]]){
        
        // Get a touch object & convert it to gl coordinates
        UITouch *myTouch = [touches anyObject];
        CGPoint location = [myTouch locationInView: [myTouch view]];
        location = [self.director convertToGL:location];
        
        // Are we currently over the center?
        if(!self.model.isOverCenter){
            
            // If we aren't, do a check to see if we do now
            if(ccpLengthSQ(ccpSub(self.center.position, location))<(150*150))
            {
                self.model.isOverCenter = YES;
            }
        }
        else{
            
            // if we are, do a check to see if we still are
            if(ccpLengthSQ(ccpSub(self.center.position, location))>(150*150))
            {
                self.model.isOverCenter = NO;
            }
        }
        
        // Update the position of the dragging sprite
        self.model.draggingSprite.position = [self.director convertToGL:[myTouch locationInView:[myTouch view]]];
    }
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // Get a touch object & convert it to gl coordinates
    UITouch* myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView: [myTouch view]];
    location = [self.director convertToGL:location];
    
    // Are we currently on the homepage?
    if([self.model.screenState isEqualToString:@"home"]){
        
        if(!self.model.canTouchFeatures) return;
        
        // Let's loop over every feature object to see if we're touching one
        CGPoint circleCenter;
        float circleRadius = 63;
        for(NSUInteger i=0; i<[self.arrItems count]; i++){
            
            // Get the position of the feature
            BeatsFeature *f = [self.arrItems objectAtIndex:i];
            circleCenter = f.position;
            
            // Check if we are touching within its radius
            if(ccpLengthSQ(ccpSub(circleCenter, location))<(circleRadius*circleRadius))
            {
                // First we stop all the actions
                [f stopAllActions];
                
                // Then we'll scale it to 1 and make him move a bit to the current position of the touch
                CCEaseOut *scaleEaseOut = [CCEaseOut actionWithAction:[CCScaleTo actionWithDuration:0.2f scale:1.0f] rate:2];
                CCEaseOut *moveEaseOut = [CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:0.2f position:location] rate:2];
                [f runAction:scaleEaseOut];
                [f runAction:moveEaseOut];
                
                // set the zOrder of the center and the current object
                self.center.zOrder = [self.children count];
                f.zOrder = [self.children count];
                
                self.dotted.position = f.data.position;
                self.dotted.visible = YES;
                
                CCRotateBy *rotate_A = [CCRotateBy actionWithDuration:8.0f angle:180];
                CCRotateBy *rotate_B = [CCRotateBy actionWithDuration:8.0f angle:180];
                CCSequence *seq = [CCSequence actions:rotate_A, rotate_B, nil];
                CCRepeatForever *rotate_inf = [CCRepeatForever actionWithAction:seq];
                [self.dotted runAction:rotate_inf];
                
                // Set the current dragging feature to the model
                self.model.draggingSprite = f;
            }
        }
    }
    
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // Get a touch object & convert it to gl coordinates
    UITouch* myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView: [myTouch view]];
    location = [self.director convertToGL:location];
    
    // Typechecking on the current dragging object
    if([self.model.draggingSprite isKindOfClass:[BeatsFeature class]]){
        
        // Stop all the actions on the current sprite and rescale back to 0.9
        [self.model.draggingSprite stopAllActions];
        CCEaseOut *scaleEaseOut = [CCEaseOut actionWithAction:[CCScaleTo actionWithDuration:0.2f scale:0.9f] rate:2];
        [self.model.draggingSprite runAction:scaleEaseOut];
        
        // Move back to your place!
        CCMoveTo *move = [CCMoveTo actionWithDuration:0.5f position:((BeatsFeature *)self.model.draggingSprite).data.position];
        CCEaseElasticOut *easeMove = [CCEaseElasticOut actionWithAction:move period:1.0f];
        CCCallBlock *afterAnimate = [CCCallBlock actionWithBlock:^{
            if(!self.model.draggingSprite) [self.dotted stopAllActions];
        }];
        CCSequence *seq = [CCSequence actions:easeMove, afterAnimate, nil];
        [self.model.draggingSprite runAction:seq];
        
    }
    
    // Are we currently over the center?
    if(self.model.isOverCenter){
        self.model.screenState = @"detail";
        self.model.isOverCenter = NO;
    }
    
    // Are we on a detail page?
    if([self.model.screenState isEqualToString:@"detail"]){
        
        // Let's check if we clicked outside the circle (on the black overlay)
        CGPoint circleCenter = self.director.screenCenter;
        float circleRadius = 257;
        if(ccpLengthSQ(ccpSub(circleCenter, location)) > (circleRadius*circleRadius)){
            self.model.screenState = @"home";
        }
        
        // Let's see if we clicked on the close button
        if([self.center.fullCircle.closeBtn containsTouch:myTouch]){
            if(ccpLengthSQ(ccpSub(self.center.position, location))<(228*228)){
                [[SimpleAudioEngine sharedEngine] playEffect:@"click_2.caf" pitch:0.8f pan:0 gain:0.2f];
                self.model.screenState = @"home";
            }
        }
        
    }
    
    self.model.draggingSprite = nil;
}

@end
