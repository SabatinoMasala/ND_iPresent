//
//  InteractiveSwitch.h
//  iPresent
//
//  Created by Sabatino on 01/05/13.
//
//

#import "CCSprite.h"
#import "AppModel.h"

@interface InteractiveSwitch : CCSprite

-(void)reset;

@property (strong, nonatomic) CCSprite *background;
@property (strong, nonatomic) CCSprite *tandwiel;
@property (strong, nonatomic) CCSprite *info;

@property (strong, nonatomic) AppModel *model;

@end
