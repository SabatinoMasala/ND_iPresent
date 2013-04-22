#import "AppDelegate.h"

@implementation AppDelegate

-(void) initializationComplete
{
    self.model = [AppModel sharedModel];
}

-(id) alternateView
{
	return nil;
}

-(void)applicationWillEnterForeground:(UIApplication *)application{
    self.model.appState = @"active";
}

-(void)applicationDidEnterBackground:(UIApplication *)application{
    self.model.appState = @"background";
}

@end
