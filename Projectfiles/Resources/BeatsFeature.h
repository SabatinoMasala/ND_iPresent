#import "CCSprite.h"
#import "BeatsFeatureData.h"

@interface BeatsFeature : CCSprite

@property (strong, nonatomic) CCSprite *circle;
@property (strong, nonatomic) CCSprite *icon;
@property (strong, nonatomic) BeatsFeatureData *data;

-(id)initWithData:(BeatsFeatureData*)data;

@end
