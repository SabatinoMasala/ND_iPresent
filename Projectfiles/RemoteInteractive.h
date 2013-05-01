//
//  RemoteInteractive.h
//  iPresent
//
//  Created by Sabatino on 01/05/13.
//
//

#import "CCSprite.h"
#import "CCButton.h"
#import "AppModel.h"
#import "InteractivePart.h"
#import <AVFoundation/AVFoundation.h>

@interface RemoteInteractive : InteractivePart <AVAudioPlayerDelegate>
@property (strong, nonatomic) CCButton *pairButton;
@property (strong, nonatomic) AppModel *model;

-(void)shutDown;

@property (strong, nonatomic) NSMutableArray *tempoFix;
@property (strong, nonatomic) AVAudioPlayer *drums;
@property (strong, nonatomic) AVAudioPlayer *guitars;
@property (strong, nonatomic) AVAudioPlayer *voice;

@property (strong, nonatomic) CCSprite *drumsSprite;
@property (strong, nonatomic) CCSprite *guitarSprite;
@property (strong, nonatomic) CCSprite *voiceSprite;


@end
