#import "cocos2d.h"
#import "BeatsFeature.h"

@interface MainScreen : CCLayer
{
	NSString* helloWorldString;
	NSString* helloWorldFontName;
	int helloWorldFontSize;
}

@property (strong, nonatomic) CCSprite *touchedSprite;

@property (strong, nonatomic) CCSprite *center;

@property (strong, nonatomic) NSMutableArray *arrItems;

@end
