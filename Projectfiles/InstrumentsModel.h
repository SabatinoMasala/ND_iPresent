//
//  BluetoothModel.h
//  iPresent
//
//  Created by Sabatino on 01/05/13.
//
//

#import <Foundation/Foundation.h>

@interface InstrumentsModel : NSObject

+(id) sharedModel;
-(void) updateSong:(NSDictionary*)elements;
-(void)applyChanges:(NSDictionary *)elements;

@property (strong, nonatomic) NSDictionary *elements;

@end