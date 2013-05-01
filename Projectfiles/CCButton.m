//
//  CCButton.m
//  iPresent
//
//  Created by Sabatino on 28/04/13.
//
//

#import "CCButton.h"

@implementation CCButton

-(id)initWithText:(NSString *)text andNormalState:(CCSprite *)normalState andActiveState:(CCSprite *)activeState{
    if(self = [super init]){
        self.isActive = NO;
        self.touchable = YES;
        self.normalState = normalState;
        self.activeState = activeState;
        self.text = text;
        self.label = [CCLabelTTF labelWithString:self.text fontName:@"Bebas Neue" fontSize:25];
        self.label.position = CGPointMake(self.normalState.contentSize.width/2, self.normalState.contentSize.height/2);
        [self addChild:self.normalState];
        self.activeState.opacity = 0;
        [self addChild:self.activeState];
        [self addChild:self.label];
        self.touchEnabled = YES;
    }
    return self;
}

-(void)setTouchable:(BOOL)touchable{
    if(_touchable != touchable){
        _touchable = touchable;
        if(!_touchable){
            _isActive = NO;
            CCFadeTo *fadeAction;
            fadeAction = [CCFadeTo actionWithDuration:.1f opacity:0];
            [self.activeState stopAllActions];
            [self.activeState runAction:fadeAction];
        }
    }
}

-(void)setIsActive:(BOOL)isActive{
    if(_isActive != isActive && self.touchable){
        _isActive = isActive;
        
        CCFadeTo *fadeAction;
        if(_isActive){
            fadeAction = [CCFadeTo actionWithDuration:.1f opacity:255];
        }
        else{
            fadeAction = [CCFadeTo actionWithDuration:.1f opacity:0];
        }
        [self.activeState stopAllActions];
        [self.activeState runAction:fadeAction];
    }
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if([self.normalState containsTouch:touch]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BTN_CLICKED" object:self];
    }
    self.isActive = NO;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if([self.normalState containsTouch:touch]){
        self.isActive = YES;
    }
}

-(void)dealloc{
    self.normalState = nil;
    self.activeState = nil;
    self.text = nil;
    self.label = nil;
    self.isActive = nil;
    self.touchable = nil;
}

@end
