#import "cocos2d.h"
#import "BeatsFeature.h"
#import "AppModel.h"
#import "CenterSprite.h"

@interface MainScreen : CCLayer
{
	NSString* helloWorldString;
	NSString* helloWorldFontName;
	int helloWorldFontSize;
}

@property (strong, nonatomic) CCDirector *director;
@property (strong, nonatomic) AppModel *model;

@property (strong, nonatomic) CenterSprite *center;
@property (strong, nonatomic) CCLabelTTF *centerLabel;

@property (strong, nonatomic) NSMutableArray *arrItems;
@property (strong, nonatomic) NSMutableArray *arrDottedLines;
@property (strong, nonatomic) NSMutableArray *arrLabels;

@end
