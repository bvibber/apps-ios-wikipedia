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

@end
