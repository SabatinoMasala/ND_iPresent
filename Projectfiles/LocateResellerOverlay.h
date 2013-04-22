#import <MapKit/MapKit.h>
#import "CCNode.h"
#import "AppModel.h"

@interface LocateResellerOverlay : CCLayer

@property (strong, nonatomic) CCLayerColor *layer;
@property (strong, nonatomic) CCLayerColor *button;
@property (strong, nonatomic) CCLayerColor *mapPlaceholder;
@property (strong, nonatomic) CCSprite *arrow;
@property (strong, nonatomic) CCLabelTTF *lblClose;

@property (strong, nonatomic) AppModel *model;

@property (strong, nonatomic) MKMapView *map;

-(void)addMapkit;
-(void)removeMapkit;

@end
