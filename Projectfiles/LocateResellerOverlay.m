#import "LocateResellerOverlay.h"
#import "AppModel.h"
#import "AFNetworking/AFNetworking.h"
#import "SimpleAudioEngine.h"

@implementation LocateResellerOverlay

-(id)init{
    if(self = [super init]){
        
        self.model = [AppModel sharedModel];
        
        float w = [CCDirector sharedDirector].screenSize.width;
        self.layer = [CCLayerColor layerWithColor:ccc4(114, 115, 115, 255) width:w height:369];
        self.layer.position = ccp(0, 42);
        self.layer.visible = NO;
        [self addChild:self.layer];
        
        self.mapPlaceholder = [CCLayerColor layerWithColor:ccc4(240, 235, 212, 255) width:604 height:337];
        self.mapPlaceholder.position = ccp(16, 58);
        [self addChild:self.mapPlaceholder];
        
        self.button = [CCLayerColor layerWithColor:ccc4(114, 115, 115, 255) width:215 height:42];
        self.button.position = ccp((w / 2) - (215 / 2), 0);
        [self addChild:self.button];
        
        self.lblClose = [CCLabelTTF labelWithString:@"find a reseller" fontName:@"Bebas Neue" fontSize:25];
        self.lblClose.position = ccp(w / 2, 22);
        [self addChild:self.lblClose];
        
        self.touchEnabled = YES;
        
    }
    return self;
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
	MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"locationPin"];
	if(!pin){
		pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"locationPin"];
		pin.pinColor = MKPinAnnotationColorRed;
		pin.canShowCallout = YES;
	}
	else{
		pin.annotation = annotation;
	}
	return pin;
}

-(void)addMapkit{
    NSLog(@"add mapkit");
    UIView *view = [CCDirector sharedDirector].view.superview;
    
    if(!self.map){
        self.map = [[MKMapView alloc] initWithFrame:CGRectMake(15, 15, 605, 338)];
        self.map.delegate = self;
        [self.map setShowsUserLocation:YES];
        
        if([CLLocationManager locationServicesEnabled]){
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
            self.locationManager.distanceFilter = 1;
            self.locationManager.delegate = self;
            [self.locationManager startUpdatingLocation];
        }
        
        // Add some caching
        if(self.model.storeLocationsJSON){
            
            [self addPins:self.model.storeLocationsJSON];
            
        }
        else{
        
            NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/nd/iPresent/api/restapi.php/stores.json"];
            NSURLRequest *req = [NSURLRequest requestWithURL:url];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                if([self.model.screenState isEqualToString:@"locator"]){
                    [self addPins:JSON];
                }
                self.model.storeLocationsJSON = JSON;
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                if([self.model.screenState isEqualToString:@"locator"]){
                    NSLog(@"Stores could not be loaded");
                }
            }];
            [operation start];
        }
        
    }
    
    [view addSubview:self.map];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if(self.model.storeLocationsJSON){
        for (NSUInteger i = 0; i<[self.model.storeLocationsJSON count]; i++) {
            NSDictionary *dict = [self.model.storeLocationsJSON objectAtIndex:i];
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:[[dict objectForKey:@"latitude"] floatValue] longitude:[[dict objectForKey:@"longitude"] floatValue]];
            NSLog(@"distance is %f", [loc distanceFromLocation:[locations objectAtIndex:0]]);
        }
    }
}

-(void) addPins:(NSArray *)JSON{
    
    for (NSUInteger i=0; i<[JSON count]; i++) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        NSDictionary *dict = [JSON objectAtIndex:i];
        annotation.coordinate = CLLocationCoordinate2DMake([[dict objectForKey:@"latitude"] floatValue], [[dict objectForKey:@"longitude"] floatValue]);
        annotation.title = [dict objectForKey:@"name"];
        annotation.subtitle = [dict objectForKey:@"name"];
        [self.map addAnnotation:annotation];
    }
    
}

-(void)removeMapkit{
    NSLog(@"removing mapkit");
    [self.map removeFromSuperview];
    self.map = nil;
    self.locationManager = nil;
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    if([self.model.screenState isEqualToString:@"home"]){
        
        if([self.button containsTouch:touch]){
            self.model.screenState = @"locator";
            [[SimpleAudioEngine sharedEngine] playEffect:@"click_2.caf" pitch:0.8f pan:0 gain:0.2f];
        }
        
    }
    
    else if([self.model.screenState isEqualToString:@"locator"]){
        if(![self.layer containsTouch:touch]){
            self.model.screenState = @"home";
            if([self.button containsTouch:touch]){
                [[SimpleAudioEngine sharedEngine] playEffect:@"click_2.caf" pitch:0.8f pan:0 gain:0.2f];
            }
        }
    }
}

@end
