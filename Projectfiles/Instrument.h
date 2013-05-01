//
//  Instrument.h
//  iPresent
//
//  Created by Sabatino on 01/05/13.
//
//

#import "CCSprite.h"

@interface Instrument : CCSprite

@property (strong, nonatomic) CCSprite *background;
@property (strong, nonatomic) CCSprite *icon;
@property (nonatomic) BOOL active;

-(id)initWithIcon:(NSString *)icon andOffset:(CGPoint)offset;
-(void)toggle;

@end
