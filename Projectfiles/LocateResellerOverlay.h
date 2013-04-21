#import "CCNode.h"
#import "AppModel.h"

@interface LocateResellerOverlay : CCLayer

@property (strong, nonatomic) CCLayerColor *layer;
@property (strong, nonatomic) CCLayerColor *button;
@property (strong, nonatomic) CCSprite *arrow;
@property (strong, nonatomic) CCLabelTTF *lblClose;

@property (strong, nonatomic) AppModel *model;

@end
