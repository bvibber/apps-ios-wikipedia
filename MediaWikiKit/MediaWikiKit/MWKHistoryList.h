//
//  MWKHistoryList.h
//  MediaWikiKit
//
//  Created by Brion on 11/17/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MediaWikiKit.h"

@class MWKTitle;
@class MWKHistoryEntry;

@interface MWKHistoryList : MWKDataObject

@property (readonly) NSUInteger length;

-(MWKHistoryEntry *)entryAtIndex:(NSUInteger)index;
-(MWKHistoryEntry *)entryForTitle:(MWKTitle *)title;

-(int)indexForEntry:(MWKHistoryEntry *)entry;
-(MWKHistoryEntry *)entryAfterEntry:(MWKHistoryEntry *)entry;
-(MWKHistoryEntry *)entryBeforeEntry:(MWKHistoryEntry *)entry;

@end
