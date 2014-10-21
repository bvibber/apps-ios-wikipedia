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

    NSString *basePath;
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
    
    NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) firstObject];
    basePath = [documentsFolder stringByAppendingPathComponent:@"unit-test-data"];

    dataStore = [[MWKDataStore alloc] initWithBasePath:basePath];
}

- (void)tearDown {
    [super tearDown];
    
    [[NSFileManager defaultManager] removeItemAtPath:basePath error:nil];
}

- (void)testWriteReadArticle
{
    XCTAssertThrows([dataStore articleWithTitle:title], @"article cannot be loaded before we save it");
    
    XCTAssertNoThrow([dataStore saveArticle:article]);
    
    MWKArticle *article2;
    XCTAssertNoThrow(article2 = [dataStore articleWithTitle:title], @"article can be loaded after saving it");
    
    XCTAssertEqualObjects(article, article2);
}

@end
