//
//  ScreenContainer.h
//  iPresent
//
//  Created by Sabatino on 28/04/13.
//
//

#import "CCLayer.h"
#import "AppModel.h"

@interface ScreenContainer : CCScene <GKPeerPickerControllerDelegate, GKSessionDelegate>

@property (strong, nonatomic) AppModel *model;

@property (strong, nonatomic) GKSession *remoteSession;
@property (strong, nonatomic) GKPeerPickerController *picker;
@property (strong, nonatomic) NSMutableArray *peers;

@end
