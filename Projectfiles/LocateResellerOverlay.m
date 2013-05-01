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
        
        self.lblErrors = [CCLabelTTF labelWithString:@"" fontName:@"Bebas Neue" fontSize:25];
        self.lblErrors.position = CGPointMake(819, 227);
        self.lblErrors.visible = NO;
        [self addChild:self.lblErrors];
        
        self.lblClosestReseller = [CCLabelTTF labelWithString:@"closest reseller near you:" fontName:@"Bebas Neue" fontSize:30];
        self.lblClosestReseller.position = CGPointMake(819, 286);
        [self addChild:self.lblClosestReseller];
        
        self.lblReseller = [CCLabelTTF labelWithString:@"Calculating" fontName:@"Futura-CondensedMedium" fontSize:25];
        self.lblReseller.position = CGPointMake(819, self.lblClosestReseller.position.y - 35);
        [self addChild:self.lblReseller];

        self.lblDistanceInKm = [CCLabelTTF labelWithString:@"distance in kilometer" fontName:@"Bebas Neue" fontSize:30];
        self.lblDistanceInKm.position = CGPointMake(819, self.lblReseller.position.y - 45);
        [self addChild:self.lblDistanceInKm];
        
        self.lblDistance = [CCLabelTTF labelWithString:@"Calculating" fontName:@"Futura-CondensedMedium" fontSize:25];
        self.lblDistance.position = CGPointMake(819, self.lblDistanceInKm.position.y - 35);
        [self addChild:self.lblDistance];
        
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

-(void)setError:(NSString *)error{
    self.lblErrors.visible = YES;
    [self.lblErrors setString:error];
    self.lblReseller.visible = NO;
    self.lblDistanceInKm.visible = NO;
    self.lblDistance.visible = NO;
    self.lblClosestReseller.visible = NO;
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
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            self.locationManager.distanceFilter = 1;
            self.locationManager.delegate = self;
            [self.locationManager startUpdatingLocation];
        }
        else{
            [self setError:@"Locations not available"];
        }
        
        // Add some caching
        if(self.model.storeLocationsJSON){
            
            [self addPins:self.model.storeLocationsJSON];
            
        }
        else{
            
            if([CLLocationManager locationServicesEnabled]){
                NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/nd/iPresent/api/restapi.php/stores.json"];
                NSURLRequest *req = [NSURLRequest requestWithURL:url];
                AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                    if([self.model.screenState isEqualToString:@"locator"]){
                        [self addPins:JSON];
                    }
                    self.model.storeLocationsJSON = JSON;
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                    if([self.model.screenState isEqualToString:@"locator"]){
                        [self setError:@"Couldn't load store locations"];
                    }
                }];
                [operation start];
            }
                
        }
        
    }
    
    [view addSubview:self.map];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if(self.model.storeLocationsJSON){
        float shortest = 0;
        NSDictionary *val;
        for (NSUInteger i = 0; i<[self.model.storeLocationsJSON count]; i++) {
            NSDictionary *dict = [self.model.storeLocationsJSON objectAtIndex:i];
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:[[dict objectForKey:@"latitude"] floatValue] longitude:[[dict objectForKey:@"longitude"] floatValue]];
            float dist = [loc distanceFromLocation:[locations objectAtIndex:0]];
            if(shortest == 0){
                shortest = dist;
                val = dict;
            }
            else{
                if(dist < shortest){
                    shortest = dist;
                    val = dict;
                }
            }
        }
        
        self.lblErrors.visible = NO;
        self.lblReseller.visible = YES;
        self.lblDistanceInKm.visible = YES;
        self.lblDistance.visible = YES;
        self.lblClosestReseller.visible = YES;
        
        [self.lblReseller setString:[val objectForKey:@"name"]];
        [self.lblDistance setString:[NSString stringWithFormat:@"%.02f km", round(shortest/10)/100]];
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
        
        if([self.button containsTouch:touch] && self.model.draggingSprite == nil){
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
