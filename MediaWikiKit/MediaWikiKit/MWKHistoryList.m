//
//  MWKHistoryList.m
//  MediaWikiKit
//
//  Created by Brion on 11/17/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MediaWikiKit.h"

@implementation MWKHistoryList {
    NSMutableArray *entries;
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        NSArray *arr = dict[@"entries"];
        if (arr) {
            entries = [[NSMutableArray alloc] init];
            for (NSDictionary *entryDict in arr) {
                MWKHistoryEntry *entry = [[MWKHistoryEntry alloc] initWithDict:entryDict];
                [entries addObject:entry];
            }
        }
    }
    return self;
}

-(NSUInteger)length
{
    return [entries count];
}

-(MWKHistoryEntry *)entryAtIndex:(NSUInteger)index
{
    return entries[index];
}

-(MWKHistoryEntry *)entryForTitle:(MWKTitle *)title
{
    for (MWKHistoryEntry *entry in entries) {
        if ([entry.title isEqual:title]) {
            return entry;
        }
    }
    return nil;
}

-(int)indexForEntry:(MWKHistoryEntry *)entry
{
    return (int)[entries indexOfObject:entry];
}

-(MWKHistoryEntry *)entryAfterEntry:(MWKHistoryEntry *)entry
{
    NSUInteger index = [self indexForEntry:entry];
    if (index == NSNotFound) {
        return nil;
    } else if (index + 1 < self.length) {
        return [self entryAtIndex:index + 1];
    } else {
        return nil;
    }
}

-(MWKHistoryEntry *)entryBeforeEntry:(MWKHistoryEntry *)entry
{
    NSUInteger index = [self indexForEntry:entry];
    if (index == NSNotFound) {
        return nil;
    } else if (index > 0) {
        return [self entryAtIndex:index - 1];
    } else {
        return nil;
    }
}

@end
