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
    [[CCDirector sharedDirector] startAnimation];
}

-(void)applicationDidEnterBackground:(UIApplication *)application{
    self.model.appState = @"background";
    [self.model bluetoothDisconnected];
    [[CCDirector sharedDirector] stopAnimation];
}

@end
