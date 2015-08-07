//
//  XMLItem.h
//  londonCycles
//
//  Created by Giulio Zicchi on 08/04/2014.
//  Copyright (c) 2014 Giulio Zicchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLItem : NSObject{

    NSString *name;
    NSString *terminalName;
    NSString *lat;
    NSString *nbBikes;
    NSString *nbEmptydocks;
    
    NSString *longitude;
    
    
    
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *terminalName;
@property (nonatomic, retain) NSString *lat;
@property (nonatomic, retain) NSString *nbBikes;
@property (nonatomic, retain) NSString *nbEmptyDocks;
@property (nonatomic, retain) NSString *longitude;


@end


