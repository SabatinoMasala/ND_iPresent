#import "CCSprite.h"
#import "BeatsFeatureData.h"
#import "AppModel.h"
#import "InteractiveSwitch.h"
#import "InteractivePart.h"
#import "RemoteInteractive.h"

@interface FullCircle : CCSprite

@property (strong, nonatomic) CCSprite *circle;
@property (strong, nonatomic) CCSprite *image;
@property (strong, nonatomic) CCSprite *closeBtn;
@property (strong, nonatomic) InteractiveSwitch *interactiveSwitch;
@property (strong, nonatomic) CCLabelTTF *lblClose;
@property (strong, nonatomic) CCLabelTTF *lblTitle;
@property (strong, nonatomic) CCLabelTTF *lblDescription;
@property (strong, nonatomic) BeatsFeatureData *data;
@property (strong, nonatomic) AppModel *model;
@property (strong, nonatomic) InteractivePart *interactivePart;

-(void)update:(BeatsFeatureData *)data;
-(void)shutDown;

@end
