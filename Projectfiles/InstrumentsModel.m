//
//  BluetoothModel.m
//  iPresent
//
//  Created by Sabatino on 01/05/13.
//
//

#import "InstrumentsModel.h"

@implementation InstrumentsModel

/* Singleton code */

static InstrumentsModel *instance;
+(id) sharedModel{
    if(!instance){
        instance = [[InstrumentsModel alloc] init];
    }
    return instance;
}

/* --------------------------------------------- */

-(id) init{
    if(self = [super init]){
    }
    return self;
}

-(void) updateSong:(NSDictionary*)elements {
    self.elements = elements;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_SONG" object:self];
}

-(void)applyChanges:(NSDictionary *)elements{
    self.elements = elements;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLY_CHANGES" object:self];
}

@end
