//
//  MWKSection.h
//  MediaWikiKit
//
//  Created by Brion on 10/7/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>

@interface MWKSection : NSObject

@property NSString *anchor;
@property NSString *index; //??
@property int tocLevel;
@property int sectionId;

@property NSDate *dateRetrieved;
@property NSString *html; //??

@end
