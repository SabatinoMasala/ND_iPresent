#import "FullCircle.h"

@implementation FullCircle

-(id)init{
    if(self=[super init]){
        self.circle = [CCSprite spriteWithFile:@"middleCircleFull.png"];
        [self addChild:self.circle];
        
        self.model = [AppModel sharedModel];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailChanged:) name:@"DETAIL_CHANGED" object:self.model];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(descriptionChanged:) name:@"DESCRIPTION_CHANGED" object:self.interactivePart];
        
        self.lblTitle = [CCLabelTTF labelWithString:@"" fontName:@"Bebas Neue" fontSize:35];
        self.lblTitle.position = ccp(0, 23);
        self.lblTitle.color = ccc3(51, 51, 51);
        [self addChild:self.lblTitle];
        
        self.lblDescription = [CCLabelTTF labelWithString:@"" fontName:@"Futura-CondensedMedium" fontSize:20];
        self.lblDescription.color = ccc3(76, 76, 76);
        self.lblDescription.position = ccp(0, -70);
        [self addChild:self.lblDescription];
        
        self.closeBtn = [CCSprite spriteWithFile:@"bottom.png"];
        self.closeBtn.position = ccp(0, -220);
        [self addChild:self.closeBtn];
        
        self.lblClose = [CCLabelTTF labelWithString:@"Close" fontName:@"Bebas Neue" fontSize:20];
        self.lblClose.color = ccc3(76, 76, 76);
        self.lblClose.position = ccp(0, -215);
        [self addChild:self.lblClose];
        
        self.interactiveSwitch = [[InteractiveSwitch alloc] init];
        self.interactiveSwitch.position = ccp(272, 80);
        [self addChild:self.interactiveSwitch];
        
    }
    return self;
}

-(void)descriptionChanged:(NSNotification *)sender{
    NSDictionary *d = [sender userInfo];
    self.lblDescription.string = [d objectForKey:@"description"];
}

-(void)detailChanged:(id)sender{
    if([self.model.detailView isEqualToString:@"interactive"]){
        
        if([self.data.icon isEqualToString:@"remote"]){
            
            self.lblTitle.string = @"interactive demo";
            
            self.interactivePart = [[RemoteInteractive alloc] init];
            self.interactivePart.position = CGPointMake(-118.5, -140);
            
            self.lblDescription.string = self.interactivePart.descr;
            self.lblDescription.position = ccp(0, -25);
            
            [self addChild:self.interactivePart];
            
        }
    
    }
    else{
        [self clean];
    }
}

-(void)shutDown{
    if(self.interactivePart){
        [self.interactivePart shutDown];
        [self.model resetBluetooth];
    }
}

-(void)clean{
    
    if(self.interactivePart){
        [self.interactivePart shutDown];
        [self.model resetBluetooth];
        
        [self.interactivePart removeFromParent];
        self.interactivePart = nil;
    }
    
    self.lblDescription.string = self.data.description;
    self.lblTitle.string = self.data.title;
    self.lblDescription.position = ccp(0, -70);
    
    self.lblDescription.visible = YES;
    self.lblTitle.visible = YES;
}

-(void)update:(BeatsFeatureData *)data{
    
    self.data = data;
    
    [self clean];
        
    if(self.image){
        [self.image removeFromParentAndCleanup:YES];
        self.image = nil;
    }
    
    if(data.interactive){
        [self.interactiveSwitch reset];
        self.interactiveSwitch.visible = YES;
    }
    else{
        self.interactiveSwitch.visible = NO;
    }
    
    self.image = [CCSprite spriteWithFile:data.image];
    self.image.position = ccp(0, 180);
    [self addChild:self.image];
}

@end