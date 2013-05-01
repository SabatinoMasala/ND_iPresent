#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CCNode.h"
#import "AppModel.h"

@interface LocateResellerOverlay : CCLayer <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CCLayerColor *layer;
@property (strong, nonatomic) CCLayerColor *button;
@property (strong, nonatomic) CCLayerColor *mapPlaceholder;
@property (strong, nonatomic) CCSprite *arrow;
@property (strong, nonatomic) CCLabelTTF *lblClose;
@property (strong, nonatomic) CCLabelTTF *lblClosestReseller;
@property (strong, nonatomic) CCLabelTTF *lblReseller;
@property (strong, nonatomic) CCLabelTTF *lblDistanceInKm;
@property (strong, nonatomic) CCLabelTTF *lblDistance;
@property (strong, nonatomic) CCLabelTTF *lblErrors;
@property (strong, nonatomic) AppModel *model;
@property (strong, nonatomic) MKMapView *map;
@property (strong, nonatomic) CLLocationManager *locationManager;

-(void)addMapkit;
-(void)removeMapkit;

@end
