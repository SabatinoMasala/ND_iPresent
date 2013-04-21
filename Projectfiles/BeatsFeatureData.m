#import "BeatsFeatureData.h"

@implementation BeatsFeatureData

/*
 * Load data into objects
 * 
 * @var dict
 *    dictionary (loaded from plist file) with the following keys:
 *      name
 *      icon
 *      description
 *      image
 *      position
 *        x
 *        y
 */
-(id)initWithData:(NSDictionary *)dict{
    if(self = [super init]){
        self.title = [dict objectForKey:@"title"];
        self.icon = [dict objectForKey:@"icon"];
        self.description = [dict objectForKey:@"description"];
        self.image = [dict objectForKey:@"image"];

        NSDictionary *pos = [dict objectForKey:@"position"];
        self.position = CGPointMake([[pos objectForKey:@"x"] intValue], [[pos objectForKey:@"y"] intValue]);
    }
    return self;
}

@end
