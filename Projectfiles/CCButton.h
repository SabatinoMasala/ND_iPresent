//
//  CCButton.h
//  iPresent
//
//  Created by Sabatino on 28/04/13.
//
//

#import "CCSprite.h"

@interface CCButton : CCLayer

@property (strong, nonatomic) CCSprite *normalState;
@property (strong, nonatomic) CCSprite *activeState;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) CCLabelTTF *label;
@property (nonatomic) BOOL isActive;
@property (nonatomic) BOOL touchable;

-(id)initWithText:(NSString *)text andNormalState:(CCNode *)normalState andActiveState:(CCNode *)activeState;

@end
