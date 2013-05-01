//
//  MainScreenIPhone.m
//  iPresent
//
//  Created by Sabatino on 28/04/13.
//
//

#import "MainScreenIPhone.h"
#import "InstrumentsModel.h"

@implementation MainScreenIPhone

-(id)init{
    if(self=[super init]){
        
        self.model = [AppModel sharedModel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeButton:) name:@"BLUETOOTH" object:self.model];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothPaired:) name:@"BLUETOOTH_CONNECT" object:self.model];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothDisconnected:) name:@"BLUETOOTH_DISCONNECT" object:self.model];
        
        self.touchEnabled = YES;
        self.director = [CCDirector sharedDirector];
        
        self.descr = @"open the iPad app and go to the remote section\nswap to the interactive remote screen\npair the devices";
        
        CCSprite *background = [CCSprite spriteWithFile:@"background-iphone.png"];
        background.position = self.director.screenCenter;
        [self addChild:background];
        
        self.title = [CCLabelTTF labelWithString:@"INSTRUCTIONS:" fontName:@"Futura-CondensedMedium" fontSize:23];
        self.title.color = ccc3(180, 179, 179);
        [self addChild:self.title];
        
        self.instructions = [CCLabelTTF labelWithString:self.descr fontName:@"Futura-CondensedMedium" fontSize:18];
        self.instructions.color = ccc3(180, 179, 179);
        [self addChild:self.instructions];
        
        self.pairButton = [[CCButton alloc] initWithText:@"pair devices"
                                          andNormalState:[CCLayerColor layerWithColor:ccc4(114, 115, 115, 255) width:237 height:53]
                                          andActiveState:[CCLayerColor layerWithColor:ccc4(85, 86, 86, 255) width:237 height:53]];
        self.pairButton.contentSize = CGSizeMake(237, 53);
        self.pairButton.position = CGPointMake(self.director.screenCenter.x - (self.pairButton.contentSize.width / 2), self.director.screenCenter.y - 80);
        [self addChild:self.pairButton];
        
        CCSprite *s = [CCSprite spriteWithFile:@"beats-remote.png"];
        s.position = CGPointMake(self.director.screenCenter.x, self.director.screenSize.height - 36);
        [self addChild:s];
        
        [self positionTitleAndLabel];
        
        [self addInstruments];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clicked:) name:@"BTN_CLICKED" object:self.pairButton];
    }
    return self;
}

-(void)bluetoothDisconnected:(id)sender {
    [self hideInstruments];
    self.pairButton.visible = YES;
    self.instructions.string = self.descr;
    [self positionTitleAndLabel];
}

-(void)positionTitleAndLabel{
    self.title.position = CGPointMake(self.director.screenCenter.x, self.director.screenCenter.y+88);
    self.instructions.position = CGPointMake(self.title.position.x, self.title.position.y - 50);
}

-(void)addInstruments{
    self.guitar = [[Instrument alloc] initWithIcon:@"guitar.png" andOffset:ccp(-4, 0)];
    self.drum = [[Instrument alloc] initWithIcon:@"drum.png" andOffset:ccp(3, 0)];
    self.voice = [[Instrument alloc] initWithIcon:@"mic.png" andOffset:ccp(0, 0)];
    
    [self addChild:self.voice];
    self.voice.position = ccp(self.director.screenCenter.x - 70, self.director.screenCenter.y - 20);
    
    [self addChild:self.guitar];
    self.guitar.position = ccp(self.director.screenCenter.x + 70, self.director.screenCenter.y - 20);
    
    [self addChild:self.drum];
    self.drum.position = ccp(self.director.screenCenter.x, self.director.screenCenter.y - 105);
    
    self.instruments = [[NSMutableArray alloc] initWithObjects:self.drum, self.guitar, self.voice, nil];
    
    [self hideInstruments];
    
}

-(void)hideInstruments{
    self.guitar.visible = NO;
    self.drum.visible = NO;
    self.voice.visible = NO;
}

-(void)showInstruments{
    self.guitar.visible = YES;
    self.drum.visible = YES;
    self.voice.visible = YES;
    
    self.guitar.active = YES;
    self.drum.active = YES;
    self.voice.active = YES;
}

-(void)clicked:(id)sender{
    self.model.bluetoothConnection = YES;
    self.pairButton.touchable = NO;
}

-(void)bluetoothPaired:(id)sender{
    self.pairButton.visible = NO;
    self.instructions.string = @"touch any object below\n\n\n";
    
    self.title.position = CGPointMake(self.director.screenCenter.x, self.director.screenCenter.y+140);
    self.instructions.position = CGPointMake(self.title.position.x, self.title.position.y - 50);
    [self showInstruments];
    
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    location = [self.director convertToGL:location];
    
    if(self.pairButton.visible) return;
    
    for (NSUInteger i = 0; i < [self.instruments count]; i++) {
        Instrument *instr = [self.instruments objectAtIndex:i];
        CGPoint p = instr.position;
        if(ccpLengthSQ(ccpSub(p, location)) < (44*44)){
            [instr toggle];
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  [NSString stringWithFormat:@"%i", self.voice.active], @"voice",
                                  [NSString stringWithFormat:@"%i", self.guitar.active], @"guitar",
                                  [NSString stringWithFormat:@"%i", self.drum.active], @"drums", nil];
            
            [[InstrumentsModel sharedModel] updateSong:dict];
        }
    }
    
}

-(void)changeButton:(id)sender{
    if(!self.model.bluetoothConnection) self.pairButton.touchable = YES;
}

@end
