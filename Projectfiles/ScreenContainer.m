//
//  ScreenContainer.m
//  iPresent
//
//  Created by Sabatino on 28/04/13.
//
//

#import "ScreenContainer.h"
#import "MainScreenIPad.h"
#import "MainScreenIPhone.h"
#import "InstrumentsModel.h"

@implementation ScreenContainer

-(id)init{
    if(self=[super init]){
        
        self.model = [AppModel sharedModel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doBluetooth:) name:@"BLUETOOTH" object:self.model];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetBluetooth:) name:@"BLUETOOTH_RESET" object:self.model];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectBluetooth:) name:@"BLUETOOTH_DISCONNECT" object:self.model];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInstruments:) name:@"UPDATE_SONG" object:[InstrumentsModel sharedModel]];
        
        NSString *device = [[UIDevice currentDevice] model];
        CCLayer *layer;
        
        // iPhone
        if([device rangeOfString:@"iPad"].location == NSNotFound){
            
            layer = [[MainScreenIPhone alloc] init];
        }
        else{
            layer = [[MainScreenIPad alloc] init];
        }
        
        [self addChild:layer];
    }
    return self;
}

-(void)disconnectBluetooth:(id)sender{
    
    if(self.pickerOpen) return;
    
    NSString *word;
    NSString *device = [[UIDevice currentDevice] model];
    if([device rangeOfString:@"iPad"].location == NSNotFound){
        word = @"application";
    }
    else{
        word = @"remote";
    }

    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Connection lost" message:[NSString stringWithFormat:@"Connection with %@ was lost", word] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    
    [message show];
    
    [self resetBluetooth:nil];
}

-(void)resetBluetooth:(id)sender{
    [self.remoteSession disconnectFromAllPeers];
    self.remoteSession = nil;
    self.picker = nil;
    self.pickerOpen = NO;
    self.peers = nil;
}

-(void)updateInstruments:(id)sender{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[[InstrumentsModel sharedModel] elements]];
    
    [self.remoteSession sendData:data toPeers:self.peers withDataMode:GKSendDataReliable error:nil];
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
   	NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [[InstrumentsModel sharedModel] applyChanges:dict];
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{
	GKSession* session = [[GKSession alloc] initWithSessionID:@"be.devine.nd.iPresent" displayName:nil sessionMode:GKSessionModePeer];
    return session;
}

-(void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
    if(state == GKPeerStateConnected){
        self.peers = [[NSMutableArray alloc] initWithObjects:peerID, nil];
        [session setDataReceiveHandler:self withContext:nil];
    }
    if(state == GKPeerStateDisconnected){
        [self.model bluetoothDisconnected];
    }
}

-(void)doBluetooth:(id)sender{
    if(self.model.bluetoothConnection){
        [self beginBluetooth];
    }
    else{
        self.picker = nil;
        self.pickerOpen = NO;
    }
}

-(void)beginBluetooth{
    self.picker = [[GKPeerPickerController alloc] init];
    self.picker.delegate = self;
    self.picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    [self.picker show];
    self.pickerOpen = YES;
}

-(void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
    self.remoteSession = session;
    session.delegate = self;
    self.model.isConnectedBluetooth = YES;
    [self.picker dismiss];
    self.pickerOpen = NO;
    self.picker.delegate = nil;
}

-(void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker{
    self.model.bluetoothConnection = NO;
}


@end
