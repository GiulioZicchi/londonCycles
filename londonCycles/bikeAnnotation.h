//
//  bikeAnnotation.h
//  mapTests
//
//  Created by Giulio Zicchi on 08/04/2014.
//  Copyright (c) 2014 Giulio Zicchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MapKit;


@interface bikeAnnotation : NSObject<MKAnnotation>{
    
    NSString *title;
    NSString *subtitle;
    NSString *note;
    CLLocationCoordinate2D coordinate;
    
    
}

@property(nonatomic, copy) NSString * title;
@property(nonatomic, copy) NSString * subtitle;
@property(nonatomic, assign)CLLocationCoordinate2D coordinate;



@end
