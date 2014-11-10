//
//  MWKSavedPageStore.m
//  MediaWikiKit
//
//  Created by Brion on 11/10/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MediaWikiKit.h"

@implementation MWKSavedPageStore {
    NSArray *savedPages;
}


-(instancetype)initWithDataStore:(MWKDataStore *)dataStore
{
    self = [self init];
    if (self) {
        _dataStore = dataStore;
        savedPages = nil;
    }
    return self;
}

-(BOOL)isPageSaved:(MWKTitle *)title
{
    [self load];
    for (NSDictionary *entry in savedPages) {
        if ([entry[@"title"] isEqualToString:title.prefixedText] &&
            [entry[@"domain"] isEqualToString:title.site.domain] &&
            [entry[@"language"] isEqualToString:title.site.language]) {
            return YES;
        }
    }
    return NO;
}

-(void)savePage:(MWKTitle *)title
{
    [self load];
    [self save];
}

#pragma mark - private methods

-(void)load
{
    if (savedPages == nil) {
        NSString *path = [self.dataStore pathForPath:@"SavedPages.plist"];
        savedPages = [NSArray arrayWithContentsOfFile:path];
    }
}

-(void)save
{
}

@end
