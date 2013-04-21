#import "CCSprite.h"
#import "BeatsFeatureData.h"

@interface FullCircle : CCSprite

@property (strong, nonatomic) CCSprite *circle;
@property (strong, nonatomic) CCSprite *image;
@property (strong, nonatomic) CCSprite *closeBtn;
@property (strong, nonatomic) CCLabelTTF *lblClose;
@property (strong, nonatomic) CCLabelTTF *lblTitle;
@property (strong, nonatomic) CCLabelTTF *lblDescription;

-(void)update:(BeatsFeatureData *)data;

@end
