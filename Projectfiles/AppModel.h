#import <Foundation/Foundation.h>
#import "BeatsFeature.h"

@interface AppModel : NSObject

extern NSString * const kTOGGLE_CENTER_SIZE;
extern NSString * const kSCREEN_STATE_CHANGED;

+(id) sharedModel;
-(void) toggleDetailView;
-(void)resetBluetooth;
-(void)bluetoothDisconnected;

@property (nonatomic) BOOL isOverCenter;
@property (nonatomic) BOOL canTouchFeatures;
@property (strong, nonatomic) NSString *screenState;
@property (strong, nonatomic) NSString *prevScreenState;
@property (strong, nonatomic) BeatsFeature *draggingSprite;
@property (strong, nonatomic) NSString *appState;
@property (strong, nonatomic) NSArray *storeLocationsJSON;
@property (nonatomic) BOOL bluetoothConnection;
@property (nonatomic) BOOL isConnectedBluetooth;
@property (strong, nonatomic) NSString *detailView;


@end