//
//  AppDelegate.h
//  londonCycles
//
//  Created by Giulio Zicchi on 30/07/2015.
//  Copyright (c) 2015 Giulio Zicchi. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@class rootViewController;


@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *myLocationManager;
@property (strong, nonatomic) rootViewController *myRootViewController;
@end

