#import "AppModel.h"
#import "SimpleAudioEngine.h"

@implementation AppModel

NSString * const kTOGGLE_CENTER_SIZE = @"TOGGLE_CENTER_SIZE";
NSString * const kSCREEN_STATE_CHANGED = @"SCREEN_STATE_CHANGED";

/* Singleton code */

static AppModel *instance;
+(id) sharedModel{
    if(!instance){
        instance = [[AppModel alloc] init];
    }
    return instance;
}

/* --------------------------------------------- */

-(id) init{
    if(self = [super init]){
        _isOverCenter = NO;
        _screenState = @"home";
        _appState = @"active";
        self.canTouchFeatures = YES;
    }
    return self;
}

-(void)bluetoothDisconnected{
    if(_bluetoothConnection || _isConnectedBluetooth){
        _bluetoothConnection = NO;
        _isConnectedBluetooth = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BLUETOOTH_DISCONNECT" object:self];
    }
}

-(void)resetBluetooth{
    _bluetoothConnection = NO;
    _isConnectedBluetooth = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BLUETOOTH_RESET" object:self];
}

-(void) toggleDetailView{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click_2.caf" pitch:1.0f pan:0 gain:0.2f];
    if([self.detailView isEqualToString:@"interactive"]){
        self.detailView = @"info";
    }
    else{
        self.detailView = @"interactive";
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DETAIL_CHANGED" object:self];
}

-(void)setBluetoothConnection:(BOOL)bluetoothConnection{
    if(_bluetoothConnection != bluetoothConnection){
        _bluetoothConnection = bluetoothConnection;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BLUETOOTH" object:self];
    }
}

-(void)setIsConnectedBluetooth:(BOOL)isConnectedBluetooth{
    if(_isConnectedBluetooth != isConnectedBluetooth){
        _isConnectedBluetooth = isConnectedBluetooth;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BLUETOOTH_CONNECT" object:self];
    }
}

-(void)setAppState:(NSString *)appState{
    if(appState != _appState){
        _appState = appState;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"APP_STATE_CHANGED" object:self];
    }
}

-(void)setScreenState:(NSString *)screenState{
    if(![_screenState isEqualToString:screenState]){
        self.prevScreenState = _screenState;
        _screenState = screenState;
        [[NSNotificationCenter defaultCenter] postNotificationName:kSCREEN_STATE_CHANGED object:self];
    }
}

-(void)setDraggingSprite:(BeatsFeature *)draggingSprite{
    if(draggingSprite != _draggingSprite){
        if(draggingSprite) [[SimpleAudioEngine sharedEngine] playEffect:@"click_2.caf" pitch:1.0f pan:0 gain:0.2f];
        _draggingSprite = draggingSprite;
    }
}

-(void)setIsOverCenter:(BOOL)isOverCenter{
    if(isOverCenter != _isOverCenter){
        if(isOverCenter) [[SimpleAudioEngine sharedEngine] playEffect:@"click_1.caf" pitch:1.0f pan:0 gain:0.3f];
        _isOverCenter = isOverCenter;
        [[NSNotificationCenter defaultCenter] postNotificationName:kTOGGLE_CENTER_SIZE object:self];
    }
}

@end
