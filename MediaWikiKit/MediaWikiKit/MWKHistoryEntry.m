//
//  MWKHistoryList.m
//  MediaWikiKit
//
//  Created by Brion on 11/3/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MediaWikiKit.h"

@implementation MWKHistoryEntry

-(instancetype)initWithTitle:(MWKTitle *)title discoveryMethod:(int)discoveryMethod
{
    self = [self initWithSite:title.site];
    if (self) {
        _title = title;
        _date = [[NSDate alloc] init];
        _discoveryMethod = discoveryMethod;
        _scrollPosition = 0;
    }
    return self;
}

-(id)dataExport
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    dict[@"title"] = self.title.prefixedDBKey;
    dict[@"date"] = [self iso8601DateString:self.date];
    dict[@"discoveryMethod"] = @"FIXME"; // get name for thingy
    dict[@"scrollPosition"] = @(self.scrollPosition);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
