//
//  XMLParser.h
//  zTFL
//
//  Created by Giulio Zicchi on 08/04/2014.
//  Copyright (c) 2014 Giulio Zicchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "defines.h"
#import "XMLItem.h"


@interface XMLParser : NSObject<NSXMLParserDelegate> {
    //This variable will eventually (once the asynchronous event has completed) hold all the XMLItems in the feed
    NSMutableArray *allItems;
    
    //This variable will be used to map properties in the XML to properties in the RSSItem object
    NSMutableArray *propertyMap;
    
    //This variable will be used to build up the data coming back from NSURLConnection
    NSMutableData *receivedData;
    
    //This item will be declared and created each time a new RSS item is encountered in the XML
    XMLItem *currentItem;
    
    //This stores the value of the XML element that is currently being processed
    NSMutableString *currentValue;
    
    //This allows the creating object to know when parsing has completed
    BOOL parsing;
    
    //This internal variable allows the object to know if the current property is inside an item element
    BOOL inItemElement;
}

@property (nonatomic, readonly) NSMutableArray *allItems;
@property (nonatomic, retain) NSMutableArray *propertyMap;
@property (nonatomic, retain) NSData *receivedData;
@property (nonatomic, retain) XMLItem *currentItem;
@property (nonatomic, retain) NSMutableString *currentValue;
@property BOOL parsing;

//This method kicks off a parse of a URL at a specified string
- (void)startParse:(NSString*)url;

@end
