//
//  MWKSavedPageList.m
//  MediaWikiKit
//
//  Created by Brion on 11/3/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MediaWikiKit.h"

@implementation MWKSavedPageList {
    NSMutableArray *entries;
    NSMutableDictionary *entriesByTitle;
}

-(NSUInteger)length
{
    return [entries count];
}

-(MWKSavedPageEntry *)entryAtIndex:(NSUInteger)index
{
    return entries[index];
}

-(MWKSavedPageEntry *)entryForTitle:(MWKTitle *)title
{
    MWKSavedPageEntry *entry = entriesByTitle[title];
    return entry;
}

-(BOOL)isSaved:(MWKTitle *)title
{
    MWKSavedPageEntry *entry = [self entryForTitle:title];
    return (entry != nil);
}

-(int)indexForEntry:(MWKHistoryEntry *)entry
{
    return (int)[entries indexOfObject:entry];
}


#pragma mark - data i/o methods

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        NSArray *array = dict[@"entries"];
        entries = [[NSMutableArray alloc] init];
        entriesByTitle = [[NSMutableDictionary alloc] init];
        for (NSDictionary *entryDict in array) {
            MWKSavedPageEntry *entry = [[MWKSavedPageEntry alloc] initWithDict:entryDict];
            [entries addObject:entry];
            entriesByTitle[entry.title] = entry;
        }
    }
    return self;
}

-(id)dataExport
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (MWKSavedPageEntry *entry in entries) {
        [array addObject:[entry dataExport]];
    }
    
    return @{@"entries": [NSArray arrayWithArray:array]};
}


@end
