#import <Foundation/Foundation.h>

@interface BeatsFeatureData : NSObject

-(id)initWithData:(NSDictionary *)dict;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *description;
@property (nonatomic) CGPoint position;
@property (nonatomic) BOOL interactive;

@end
