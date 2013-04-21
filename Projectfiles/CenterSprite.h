#import "CCSprite.h"
#import "AppModel.h"

@interface CenterSprite : CCSprite

@property (strong, nonatomic) CCSprite *circle;
@property (strong, nonatomic) AppModel *model;

-(id)init;

@end
