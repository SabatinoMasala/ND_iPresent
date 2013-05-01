//
//  RemoteInteractive.m
//  iPresent
//
//  Created by Sabatino on 01/05/13.
//
//

#import "RemoteInteractive.h"
#import "InstrumentsModel.h"

@implementation RemoteInteractive

-(id)init{
    if(self=[super init]){
        
        self.model = [AppModel sharedModel];
        
        self.descr = @"open up this app on your iPhone and hit connect\nhit connect below";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeButton:) name:@"BLUETOOTH" object:self.model];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothPaired:) name:@"BLUETOOTH_CONNECT" object:self.model];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothDisconnect:) name:@"BLUETOOTH_DISCONNECT" object:self.model];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSong:) name:@"APPLY_CHANGES" object:[InstrumentsModel sharedModel]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnClicked:) name:@"BTN_CLICKED" object:self.pairButton];
        
        self.pairButton = [[CCButton alloc] initWithText:@"pair devices"
                                          andNormalState:[CCLayerColor layerWithColor:ccc4(114, 115, 115, 255) width:237 height:53]
                                          andActiveState:[CCLayerColor layerWithColor:ccc4(85, 86, 86, 255) width:237 height:53]];
        [self addChild:self.pairButton];
        
        self.guitarSprite = [[CCSprite alloc] initWithFile:@"guitarBlack.png"];
        self.voiceSprite = [[CCSprite alloc] initWithFile:@"micBlack.png"];
        self.drumsSprite = [[CCSprite alloc] initWithFile:@"drumBlack.png"];
        
        [self addChild:self.guitarSprite];
        [self addChild:self.voiceSprite];
        [self addChild:self.drumsSprite];
        
        self.guitarSprite.position = ccp(20, 30);
        self.voiceSprite.position = ccp(120, 30);
        self.drumsSprite.position = ccp(220, 30);
        
        [self hideSprites];
        
    }
    return self;
}

-(void)bluetoothDisconnect:(id)sender{
    
    [self hideSprites];
    [self shutDown];
    self.pairButton.visible = YES;
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.descr, @"description", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DESCRIPTION_CHANGED" object:self userInfo:dict];
    
}

-(void)hideSprites{
    self.guitarSprite.visible = NO;
    self.voiceSprite.visible = NO;
    self.drumsSprite.visible = NO;
}

-(void)showSprites{    
    self.guitarSprite.visible = YES;
    self.voiceSprite.visible = YES;
    self.drumsSprite.visible = YES;
    self.guitarSprite.opacity = 255;
    self.voiceSprite.opacity = 255;
    self.drumsSprite.opacity = 255;
}

-(void)btnClicked:(id)sender{
    self.pairButton.touchable = NO;
    self.model.bluetoothConnection = YES;
}

-(void)changeButton:(id)sender{
    self.pairButton.touchable = YES;
}

-(void)shutDown{
    [self.drums stop];
    [self.guitars stop];
    [self.voice stop];
    self.tempoFix = [[NSMutableArray alloc] init];
}

-(void)bluetoothPaired:(id)sender{
    self.pairButton.visible = NO;
    [self showSprites];

    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"mute parts of the song using the remote\n\n", @"description", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DESCRIPTION_CHANGED" object:self userInfo:dict];
    
    [self playSounds];
    
}

-(void)updateSong:(id)sender{
    NSDictionary *dict = [[InstrumentsModel sharedModel] elements];
    BOOL playDrums = [[dict objectForKey:@"drums"] intValue];
    BOOL playVoice = [[dict objectForKey:@"voice"] intValue];
    BOOL playGuitar = [[dict objectForKey:@"guitar"] intValue];
    
    float t = 0.2f;
    uint drumOpacity;
    uint voicesOpacity;
    uint guitarOpacity;
    
    if(playDrums){
        [self.drums setVolume:1.0f];
        drumOpacity = 255;
    }
    else{
        [self.drums setVolume:0.0f];
        drumOpacity = 40;
    }
    CCFadeTo *drumFade = [CCFadeTo actionWithDuration:t opacity:drumOpacity];
    [self.drumsSprite runAction:drumFade];
    
    if(playVoice){
        [self.voice setVolume:1.0f];
        voicesOpacity = 255;
    }
    else{
        [self.voice setVolume:0.0f];
        voicesOpacity = 40;
    }
    CCFadeTo *voiceFade = [CCFadeTo actionWithDuration:t opacity:voicesOpacity];
    [self.voiceSprite runAction:voiceFade];
    
    if(playGuitar){
        [self.guitars setVolume:1.0f];
        guitarOpacity = 255;
    }
    else{
        [self.guitars setVolume:0.0f];
        guitarOpacity = 40;
    }
    CCFadeTo *guitarFade = [CCFadeTo actionWithDuration:t opacity:guitarOpacity];
    [self.guitarSprite runAction:guitarFade];
}

-(void)playSounds{
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/drum-bass.mp3", [[NSBundle mainBundle] resourcePath]]];
	NSURL *url2 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/guitars.mp3", [[NSBundle mainBundle] resourcePath]]];
	NSURL *url3 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/voice-ambient.mp3", [[NSBundle mainBundle] resourcePath]]];
	
	NSError *error;
    
    self.tempoFix = [[NSMutableArray alloc] init];
    
    self.drums = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.drums.delegate = self;
    [self.drums play];
    
    self.guitars = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:&error];
    self.guitars.delegate = self;
    [self.guitars play];
    
    self.voice = [[AVAudioPlayer alloc] initWithContentsOfURL:url3 error:&error];
    self.voice.delegate = self;
    [self.voice play];
    
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self.tempoFix addObject:player];
    if([self.tempoFix count] == 3){
        [self.drums play];
        [self.guitars play];
        [self.voice play];
        self.tempoFix = [[NSMutableArray alloc] init];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.model = nil;
    self.pairButton = nil;
}

@end
