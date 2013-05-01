//
//  Instrument.m
//  iPresent
//
//  Created by Sabatino on 01/05/13.
//
//

#import "Instrument.h"

@implementation Instrument

-(id)initWithIcon:(NSString *)icon andOffset:(CGPoint)offset{
    if(self=[super init]){
        self.cascadeOpacityEnabled = YES;
        self.background = [CCSprite spriteWithFile:@"featureCircle110.png"];
        self.background.scale = .76;
        [self addChild:self.background];
        
        self.active = YES;
        
        self.icon = [CCSprite spriteWithFile:icon];
        [self addChild:self.icon];
        self.icon.position = offset;
        
    }
    return self;
}

-(void)setActive:(BOOL)active{
    if(_active != active){
        _active = active;
        uint opacity;
        if(_active){
            opacity = 255;
        }
        else{
            opacity = 130;
        }
        CCFadeTo *fade = [CCFadeTo actionWithDuration:0.2f opacity:opacity];
        [self runAction:fade];
    }
}

-(void)toggle{
    self.active = !self.active;
}

@end
