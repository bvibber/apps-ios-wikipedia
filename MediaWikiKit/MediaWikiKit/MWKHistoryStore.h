//
//  MWKHistoryStore.h
//  MediaWikiKit
//
//  Created by Brion on 11/10/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

// Forward decls
@class MWKTitle;
@class MWKDataStore;
@class MWKHistoryEntry;

@interface MWKHistoryStore : NSObject

@property (readonly) MWKDataStore *dataStore;

-(instancetype)initWithDataStore:(MWKDataStore *)dataStore;

@property (readonly) int length;
-(MWKHistoryEntry *)entryAtIndex:(int)index;
-(MWKHistoryEntry *)entryWithTitle:(MWKTitle *)title;

-(void)createHistoryEntryWithTitle:(MWKTitle *)title discoveryMethod:(int)discoveryMethod;

@end
