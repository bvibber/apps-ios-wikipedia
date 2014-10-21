//
//  MWKDataStoreTests.m
//  MediaWikiKit
//
//  Created by Brion on 10/21/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MediaWikiKit.h"

@interface MWKDataStoreTests : XCTestCase {
    MWKSite *site;
    MWKTitle *title;
    NSDictionary *json;
    MWKArticle *article;
    MWKDataStore *dataStore;
}

@end

@implementation MWKDataStoreTests

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

- (void)testBasePath {
    XCTAssertEqualObjects(dataStore.basePath, @"/");
}

- (void)testSitesPath {
    XCTAssertEqualObjects([dataStore pathForSites], @"/sites");
}

- (void)testSitePath {
    XCTAssertEqualObjects([dataStore pathForSite:site], @"/sites/wikipedia.org/en");
}

- (void)testArticlesPath {
    XCTAssertEqualObjects([dataStore pathForArticlesWithSite:site], @"/sites/wikipedia.org/en/articles");
}

- (void)testTitlePath {
    XCTAssertEqualObjects([dataStore pathForTitle:title], @"/sites/wikipedia.org/en/articles/San_Francisco");
}

- (void)testArticlePath {
    XCTAssertEqualObjects([dataStore pathForArticle:article], @"/sites/wikipedia.org/en/articles/San_Francisco");
}

- (void)testSectionsPath {
    XCTAssertEqualObjects([dataStore pathForSectionsWithTitle:article.title], @"/sites/wikipedia.org/en/articles/San_Francisco/sections");
}

- (void)testSectionPath {
    NSString *section0 = [[MWKSection alloc] initWithArticle:article dict:json[@"mobileview"][@"sections"][0]];
    NSString *section35 = [[MWKSection alloc] initWithArticle:article dict:json[@"mobileview"][@"sections"][35]];

    XCTAssertEqualObjects([dataStore pathForSection:section0], @"/sites/wikipedia.org/en/articles/San_Francisco/sections/section0");
    XCTAssertEqualObjects([dataStore pathForSection:section35], @"/sites/wikipedia.org/en/articles/San_Francisco/sections/section35");
}

- (NSDictionary *)loadJSON:(NSString *)name
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *err = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:nil error:&err];
    assert(err == nil);
    assert(dict);
    return dict;
}

@end
