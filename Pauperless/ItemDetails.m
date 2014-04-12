//
//  ItemDetails.m
//  Pauperless
//
//  Created by Dominic Ong on 3/30/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import "ItemDetails.h"
#import "AddItemViewController.h"

@implementation ItemDetails{
    BOOL mapHasLoaded_;
    BOOL firstLocationUpdate_;

    GMSMapView *mapView_;
}

-(void)viewDidLoad{
    
    [_quantityLabel setText: _quantity];
    [_detailLabel setText:_details];
    //_itemImage = [UIImageView alloc];
    PFQuery *imageQuery = [[PFQuery alloc] initWithClassName:@"UserPhoto"];
    [imageQuery getObjectInBackgroundWithId:_imageId block:^(PFObject *object, NSError *error) {
        if(!error){
            PFFile *theImage = [object objectForKey:@"imageFile"];
            NSData *imageData = [theImage getData];
            UIImage *image = [UIImage imageWithData:imageData];
            _itemImage.image = image;
        }
    }];
    if(_reserveButton){
        _reserveButton.layer.cornerRadius = 5.0f;
    }
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                            longitude:151.2086
                                                                 zoom:12];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.mapType = kGMSTypeNormal;
    
    // Listen to the myLocation property of GMSMapView.
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    self.view = mapView_;
}

-(void)refreshMyLocation{
    firstLocationUpdate_ = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    UINavigationBar *bar = [self navigationController].navigationBar;
    bar.topItem.title = _itemName;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"editItem"]){
        
    }
}

- (IBAction)editItem:(id)sender {
    [self performSegueWithIdentifier:@"editItem" sender:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        
        NSNumber *latitude = [[NSNumber alloc] initWithDouble:location.coordinate.latitude];
        NSNumber *longitude = [[NSNumber alloc] initWithDouble:location.coordinate.longitude];
        
        NSArray *coordinates = [[NSArray alloc] initWithObjects:latitude, longitude, nil];
        NSArray *stringCoord = [[NSArray alloc] initWithObjects:[latitude stringValue], [longitude stringValue], nil];
        NSArray *keys = [[NSArray alloc] initWithObjects:@"latitude", @"longitude", nil];
        
        NSDictionary *userCoordinates = [[NSDictionary alloc] initWithObjects:coordinates forKeys:keys];
        NSDictionary *userStringCoord = [[NSDictionary alloc] initWithObjects:stringCoord forKeys:keys];
        double lat = [[userCoordinates objectForKey:@"latitude"] doubleValue];
        double lon = [[userCoordinates objectForKey:@"longitude"] doubleValue];
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lon);
        //GMSMarker *marker = [GMSMarker markerWithPosition:position];
        //[markers_ addObject:marker];
        //marker.map = mapView_;
        
        //Add/Update user in the encounter-users
        
        if(!mapHasLoaded_){
            mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:14];
            mapHasLoaded_ = YES;
        }
        [self performSelector:@selector(refreshMyLocation) withObject:nil afterDelay:1.0];
    }else{
        
    }
}

@end
