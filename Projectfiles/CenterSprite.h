#import "CCSprite.h"
#import "AppModel.h"
#import "FullCircle.h"

@interface CenterSprite : CCSprite

@property (strong, nonatomic) CCSprite *smallCircle;
@property (strong, nonatomic) FullCircle *fullCircle;
@property (strong, nonatomic) AppModel *model;

@property (strong, nonatomic) CCLabelTTF *title;

-(id)init;

@end
