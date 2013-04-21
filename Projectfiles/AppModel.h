#import <Foundation/Foundation.h>
#import "BeatsFeature.h"

@interface AppModel : NSObject

extern NSString * const kTOGGLE_CENTER_SIZE;
extern NSString * const kCENTER_OPEN;

+(id) sharedModel;

@property (nonatomic) BOOL centerCanAcceptFeatures;
@property (nonatomic) BOOL centerOpen;
@property (strong, nonatomic) BeatsFeature *draggingSprite;

@end