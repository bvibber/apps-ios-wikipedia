//
//  MWKHistoryStore.m
//  MediaWikiKit
//
//  Created by Brion on 11/10/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MWKHistoryStore.h"

@implementation MWKHistoryStore

-(instancetype)initWithDataStore:(MWKDataStore *)dataStore
{
    self = [self init];
    if (self) {
        _dataStore = dataStore;
    }
    return self;
}

-(MWKHistoryEntry *)entryWithTitle:(MWKTitle *)title
{
    [self loadData];
}

-(void)createHistoryEntryWithTitle:(MWKTitle *)title discoveryMethod:(int)discoveryMethod
{
    [self loadData];
    MWKHistoryEntry *entry = [[MWKHistoryEntry alloc] initWithTitle:title discoveryMethod:discoveryMethod];
    [self saveData];
}


#pragma mark - private methods

- (void)loadData
{

}

- (void)saveData
{
    
}

@end
