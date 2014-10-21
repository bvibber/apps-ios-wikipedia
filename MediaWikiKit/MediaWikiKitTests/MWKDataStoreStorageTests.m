//
//  MWKDataStoreTests.m
//  MediaWikiKit
//
//  Created by Brion on 10/21/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MWKTestCase.h"

@interface MWKDataStoreStorageTests : MWKTestCase {
    MWKSite *site;
    MWKTitle *title;
    NSDictionary *json;
    MWKArticle *article;
    MWKDataStore *dataStore;
}

@end

@implementation MWKDataStoreStorageTests

- (void)setUp {
    [super setUp];
    site = [[MWKSite alloc] initWithDomain:@"wikipedia.org" language:@"en"];
    title = [site titleWithString:@"San Francisco"];
    
    json = [self loadJSON:@"section0"];
    article = [[MWKArticle alloc] initWithTitle:title dict:json[@"mobileview"]];
    
    dataStore = [[MWKDataStore alloc] initWithBasePath:@"/"];
}

- (void)tearDown {
    [super tearDown];
}

@end
