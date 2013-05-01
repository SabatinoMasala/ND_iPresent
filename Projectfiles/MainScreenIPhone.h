//
//  MainScreenIPhone.h
//  iPresent
//
//  Created by Sabatino on 28/04/13.
//
//

#import "CCLayer.h"
#import "CCButton.h"
#import "AppModel.h"
#import "Instrument.h"

@interface MainScreenIPhone : CCLayer

@property (strong, nonatomic) AppModel *model;

@property (strong, nonatomic) CCDirector *director;
@property (strong, nonatomic) CCLabelTTF *instructions;
@property (strong, nonatomic) CCLabelTTF *title;
@property (strong, nonatomic) CCButton *pairButton;
@property (strong, nonatomic) NSString *descr;

@property (strong, nonatomic) Instrument *guitar;
@property (strong, nonatomic) Instrument *voice;
@property (strong, nonatomic) Instrument *drum;

@property (strong, nonatomic) NSMutableArray *instruments;

@end
