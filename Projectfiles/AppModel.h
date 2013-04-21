#import <Foundation/Foundation.h>
#import "BeatsFeature.h"

@interface AppModel : NSObject

extern NSString * const kTOGGLE_CENTER_SIZE;
extern NSString * const kSCREEN_STATE_CHANGED;

+(id) sharedModel;

@property (nonatomic) BOOL isOverCenter;
@property (strong, nonatomic) NSString *screenState;
@property (strong, nonatomic) NSString *prevScreenState;
@property (strong, nonatomic) BeatsFeature *draggingSprite;

@end