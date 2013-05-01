//
//  InteractiveSwitch.m
//  iPresent
//
//  Created by Sabatino on 01/05/13.
//
//

#import "InteractiveSwitch.h"

@implementation InteractiveSwitch

-(id)init{
    if(self=[super init]){
        
        self.model = [AppModel sharedModel];
        
        self.background = [CCSprite spriteWithFile:@"interactive.png"];
        [self addChild:self.background];
        
        self.tandwiel = [CCSprite spriteWithFile:@"tandwiel.png"];
        [self addChild:self.tandwiel];
        
        self.info = [CCSprite spriteWithFile:@"info.png"];
        self.info.visible = NO;
        [self addChild:self.info];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailChanged:) name:@"DETAIL_CHANGED" object:self.model];
        
    }
    return self;
}

-(void)reset{
    self.model.detailView = @"info";
    self.tandwiel.visible = YES;
    self.info.visible = NO;
}

-(void)detailChanged:(id)sender{
    
    [self stopAllActions];
    
    CCScaleTo *c = [CCScaleTo actionWithDuration:0.1f scale:1.1];
    CCScaleTo *c2 = [CCScaleTo actionWithDuration:0.7f scale:1];
    CCEaseExponentialOut *scaleEase = [CCEaseExponentialOut actionWithAction:c2];
    
    CCSequence *seq = [CCSequence actions:c, scaleEase, nil];
    [self runAction:seq];
    
    if([self.model.detailView isEqualToString:@"interactive"]){
        self.tandwiel.visible = NO;
        self.info.visible = YES;
    }
    else{
        self.tandwiel.visible = YES;
        self.info.visible = NO;
    }
}

@end
