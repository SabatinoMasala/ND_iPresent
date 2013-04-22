#import "KKAppDelegate.h"
#import "AppModel.h"

@interface AppDelegate : KKAppDelegate
{
}

@property (strong, nonatomic) AppModel *model;

@end

@compatibility_alias AppController AppDelegate;
