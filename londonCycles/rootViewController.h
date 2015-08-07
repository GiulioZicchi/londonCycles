//
//  rootViewController.h
//  londonCycles
//
//  Created by Giulio Zicchi on 30/07/2015.
//  Copyright (c) 2015 Giulio Zicchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defines.h"
#import "XMLParser.h"
#import "bikeAnnotation.h"

@import CoreLocation;
@import MapKit;

@class AppDelegate;


@interface rootViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic,strong) UINavigationController *myNavigationController;

@property(nonatomic) float zoomLevel;

@end
