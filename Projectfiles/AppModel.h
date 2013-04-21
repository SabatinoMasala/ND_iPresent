#import <Foundation/Foundation.h>

@interface AppModel : NSObject

extern NSString * const kTOGGLE_CENTER_SIZE;

+(id) sharedModel;

@property (nonatomic) BOOL centerCanAcceptFeatures;
@property (strong, nonatomic) CCSprite *draggingSprite;

@end