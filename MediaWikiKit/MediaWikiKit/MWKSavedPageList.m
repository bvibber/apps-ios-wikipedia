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

-(instancetype)initWithArray:(NSArray *)array
{
    self = [self init];
    if (self) {
        entries = [[NSMutableArray alloc] init];
        entriesByTitle = [[NSMutableDictionary alloc] init];
        for (NSDictionary *dict in array) {
            MWKSavedPageEntry *entry = [[MWKSavedPageEntry alloc] initWithDict:dict];
            [entries addObject:entry];
            entriesByTitle[entry.title] = entry;
        }
    }
    return self;
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

-(id)dataExport
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (MWKSavedPageEntry *entry in entries) {
        [array addObject:[entry dataExport]];
    }
    
    return [NSArray arrayWithArray:array];
}


@end
