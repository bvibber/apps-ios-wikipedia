//
//  MWKHistoryList.h
//  MediaWikiKit
//
//  Created by Brion on 11/3/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MWKSiteDataObject.h"

@class MWKTitle;

@interface MWKHistoryEntry : MWKSiteDataObject

@property (readonly) MWKTitle *title;
@property (readwrite) NSDate *date;
@property (readwrite) int discoveryMethod;
@property (readwrite) int scrollPosition;

-(instancetype)initWithTitle:(MWKTitle *)title discoveryMethod:(int)discoveryMethod;

@end
