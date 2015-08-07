//
//  rootViewController.m
//  londonCycles
//
//  Created by Giulio Zicchi on 30/07/2015.
//  Copyright (c) 2015 Giulio Zicchi. All rights reserved.
//

#import "rootViewController.h"
#import "AppDelegate.h"

#define iphoneScaleFactorLatitude   13
#define iphoneScaleFactorLongitude  15

@implementation rootViewController{
    
    XMLParser *bikeParser;
    CLLocationManager *myLocationManager;
    MKMapView *myMapView;
    NSMutableArray *bikeAnnotations;
    UIColor *routeColour;
    
}

@synthesize myNavigationController,zoomLevel;


//------------------------------------------------------------------------------------------------------------

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //--------------------------------------------------------------------
    // get objects from app delegate
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];    // typecast succeeds
    myLocationManager = delegate.myLocationManager;
    
    
    //-----------------------------------------------------------------------------
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bikesParsed)
                                                 name:@"bikesParsed"
                                               object:nil];
    

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"London Cycles";

    //-----------------------------------------------------------------------------
    
    [myNavigationController setToolbarHidden:NO];
    
    //-----------------------------------------------------------------------------
    // location inits
    
    myLocationManager = [[CLLocationManager alloc] init];
    myLocationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    myLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    myLocationManager.delegate = self;
    [myLocationManager startUpdatingLocation];
    
    //-----------------------------------------------------------------------------
    // map inits
    
    myMapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:myMapView];
    myMapView.showsUserLocation = true;
    myMapView.delegate = self;
    
    MKUserTrackingBarButtonItem *trackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:myMapView];
    [self setToolbarItems:@[trackingButton]];
    

    //-----------------------------------------------------------------------------
    // set initialised map to show London at zoom level chosen to see all bike stations
    
    CLLocationCoordinate2D londonLocation = CLLocationCoordinate2DMake(51.507, -0.127);
    
    myMapView.region = MKCoordinateRegionMakeWithDistance(londonLocation, 25000, 25000);
    
    
    //-----------------------------------------------------------------------------
    // go get xml feed of all bike stations from TFL
    
    bikeParser = [XMLParser new];
    [bikeParser startParse:@"http://www.tfl.gov.uk/tfl/syndication/feeds/cycle-hire/livecyclehireupdates.xml"];
    
    
    
    
}



//------------------------------------------------------------------------------------------------------------

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    myMapView.frame = self.view.bounds;
}

//------------------------------------------------------------------------------------------------------------


-(void)bikesParsed{
    
    ZLog(@"Got bike info...")
    
    NSLog(@"Got Message!");
    
    bikeAnnotations = [NSMutableArray new];
    
    for(XMLItem *bikeStation in bikeParser.allItems){
        
        float myLat = [bikeStation.lat floatValue];
        float myLong = [bikeStation.longitude floatValue];
        
        CLLocationCoordinate2D myCoordinate;
        myCoordinate.latitude = myLat;
        myCoordinate.longitude = myLong;
        
        
        bikeAnnotation *newBikeAnnotation = [bikeAnnotation new];
        
        newBikeAnnotation.coordinate = myCoordinate;
        newBikeAnnotation.title = bikeStation.name;
        
        
        
        NSString *bikesFree = @"Bikes Available: ";
        bikesFree = [bikesFree stringByAppendingString:bikeStation.nbBikes];
        bikesFree = [bikesFree stringByAppendingString:@" Empty Docks: "];
        bikesFree = [bikesFree stringByAppendingString:bikeStation.nbEmptyDocks];
        
        newBikeAnnotation.subtitle = bikesFree;
        
        [bikeAnnotations addObject:newBikeAnnotation];
        
        
    }
    
    for(MKPointAnnotation *annotation in bikeAnnotations){
        
        [myMapView addAnnotation:annotation];
    }
    
    [self filterAnnotations:bikeAnnotations];
    
    
}

//------------------------------------------------------------------------------------------------------------

-(void)filterAnnotations:(NSArray *)placesToFilter{
    
    float latDelta = myMapView.region.span.latitudeDelta/iphoneScaleFactorLatitude;
    float longDelta = myMapView.region.span.longitudeDelta/iphoneScaleFactorLongitude;
    

    NSMutableArray *bikesToShow=[[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i=0; i<[placesToFilter count]; i++) {
        bikeAnnotation *checkingLocation=[placesToFilter objectAtIndex:i];
        CLLocationDegrees latitude = checkingLocation.coordinate.latitude;
        CLLocationDegrees longitude = checkingLocation.coordinate.longitude;
        
        
        bool found=FALSE;
        for (bikeAnnotation *tempPlacemark in bikesToShow){
            
            if(fabs(tempPlacemark.coordinate.latitude-latitude) < latDelta &&
               fabs(tempPlacemark.coordinate.longitude-longitude) <longDelta ){
                
                
                [myMapView removeAnnotation:checkingLocation];
                found=TRUE;
                break;
            }
        }
        if (!found) {
            [bikesToShow addObject:checkingLocation];
            [myMapView addAnnotation:checkingLocation];
        }
        
    }
}


//------------------------------------------------------------------------------------------------------------

#pragma  mark CLLocationManager delegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //ZLog(@"LM Updating...");
    
}


-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    ZLog(@"%@",oldLocation);
    ZLog(@"%@",newLocation);
    
}

//------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------

#pragma mark MKMapView delegate methods


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
    NSLog(@"Region will change");
}

//------------------------------------------------------------------------------------------------

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    NSLog(@"Region did change");
    
    if (zoomLevel!= myMapView.region.span.longitudeDelta) {
        [self filterAnnotations:bikeAnnotations];
        zoomLevel = myMapView.region.span.longitudeDelta;
    }
    
    
}

//------------------------------------------------------------------------------------------------

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    else if ([annotation isKindOfClass:[bikeAnnotation class]]){
        
        static NSString * const identifier = @"MyCustomAnnotation";
        
        MKAnnotationView *annotationView = [myMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView){
            annotationView.annotation = annotation;
        } else {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:identifier];
        }
        
        annotationView.canShowCallout = YES;
        UIImage *bikeImage  = [UIImage imageNamed:@"bike.gif"];
        annotationView.image = bikeImage;
        
        return annotationView;
    }
    return nil;

    
}

//------------------------------------------------------------------------------------------------


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    NSLog(@"Annotation Selected");
    
    view.canShowCallout = YES;
    //view.image = [ UIImage imageNamed:@"bike.gif" ];
    
    view.rightCalloutAccessoryView = [ UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    UIImageView *imgView = [ [ UIImageView alloc ] initWithImage:[ UIImage imageNamed:@"bike.gif" ] ];
    view.leftCalloutAccessoryView = imgView;
    
}

//------------------------------------------------------------------------------------------------


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    ZLog(@"%@",control)
    
    [myMapView removeOverlays:myMapView.overlays];
    
    MKDirectionsRequest *dirRequest = [[MKDirectionsRequest alloc] init];
    dirRequest.source = [MKMapItem mapItemForCurrentLocation];
    //dirRequest.requestsAlternateRoutes = YES;
    
    
    bikeAnnotation *whichAnnotation = view.annotation;
    
    float destinationLat = whichAnnotation.coordinate.latitude;
    float destinationLong = whichAnnotation.coordinate.longitude;
    
    CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(destinationLat, destinationLong);
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    MKMapItem *destinationMapItem = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    
    dirRequest.destination = destinationMapItem;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:dirRequest];

    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error){
        
        if(error){
            
            ZLog(@"Shitting Cock!")
            
        } else {
            
            [self showDirectionsOnMap:response];
            
        }
    
    }];
     
    
}

//------------------------------------------------------------------------------------------------

-(void)showDirectionsOnMap:(MKDirectionsResponse *)response{

    
    ZLog(@"NUMBER OF ROUTES: %lu",(unsigned long)[response.routes count])
    

    for(MKRoute *route in response.routes){

        /*
        for(MKRouteStep *step in route.steps){
            
            ZLog(@"%@",step.instructions);
            
        }
        */
    
        [myMapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];

    }

    
}

//------------------------------------------------------------------------------------------------

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    
    if([overlay isKindOfClass:[MKPolyline class]]){
        
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        renderer.lineWidth = 3;
        
        renderer.strokeColor = [UIColor blueColor];
        
        return renderer;
        
    } else {
        
        return  nil;
    }
        
}

//------------------------------------------------------------------------------------------------------------

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    

    
}

//------------------------------------------------------------------------------------------------------------


@end
