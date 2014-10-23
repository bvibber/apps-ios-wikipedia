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
    NSDictionary *json0;
    NSDictionary *json1;

    NSString *basePath;
    MWKDataStore *dataStore;
}

@end

@implementation MWKDataStoreStorageTests

- (void)setUp {
    [super setUp];
    site = [[MWKSite alloc] initWithDomain:@"wikipedia.org" language:@"en"];
    title = [site titleWithString:@"San Francisco"];
    
    json0 = [self loadJSON:@"section0"];
    json1 = [self loadJSON:@"section1-end"];
    
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
    
    MWKArticle *article;
    article = [[MWKArticle alloc] initWithTitle:title dict:json0[@"mobileview"]];

    XCTAssertNoThrow([dataStore saveArticle:article]);
    
    MWKArticle *article2;
    XCTAssertNoThrow(article2 = [dataStore articleWithTitle:title], @"article can be loaded after saving it");
    
    XCTAssertEqualObjects(article, article2);
}

- (void)testArticleStoreSection0
{
    XCTAssertThrows([dataStore articleWithTitle:title], @"article cannot be loaded before we save it");
    
    MWKArticleStore *articleStore = [dataStore articleStoreWithTitle:title];
    XCTAssertNoThrow([articleStore importMobileViewJSON:json0]);
    
    MWKArticle *article;
    XCTAssertNoThrow(article = [dataStore articleWithTitle:title], @"article can be loaded after saving it");
    
    NSFileManager *fm = [NSFileManager defaultManager];
    XCTAssertTrue([fm fileExistsAtPath:[[dataStore pathForTitle:title] stringByAppendingPathComponent:@"Article.plist"]]);
    XCTAssertTrue([fm fileExistsAtPath:[[dataStore pathForSectionId:0 title:title] stringByAppendingPathComponent:@"Section.plist"]]);
    XCTAssertTrue([fm fileExistsAtPath:[[dataStore pathForSectionId:0 title:title] stringByAppendingPathComponent:@"Section.html"]]);
    XCTAssertTrue([fm fileExistsAtPath:[[dataStore pathForSectionId:35 title:title] stringByAppendingPathComponent:@"Section.plist"]]);
    XCTAssertFalse([fm fileExistsAtPath:[[dataStore pathForSectionId:35 title:title] stringByAppendingPathComponent:@"Section.html"]]);
}

- (void)testArticleStoreSection1ToEnd
{
    MWKArticleStore *articleStore = [dataStore articleStoreWithTitle:title];
    XCTAssertNoThrow([articleStore importMobileViewJSON:json0]);
    XCTAssertNoThrow([articleStore importMobileViewJSON:json1]);
    
    MWKArticle *article;
    XCTAssertNoThrow(article = [dataStore articleWithTitle:title], @"article can be loaded after saving it");
    
    NSFileManager *fm = [NSFileManager defaultManager];
    XCTAssertTrue([fm fileExistsAtPath:[[dataStore pathForTitle:title] stringByAppendingPathComponent:@"Article.plist"]]);
    XCTAssertTrue([fm fileExistsAtPath:[[dataStore pathForSectionId:0 title:title] stringByAppendingPathComponent:@"Section.plist"]]);
    XCTAssertTrue([fm fileExistsAtPath:[[dataStore pathForSectionId:0 title:title] stringByAppendingPathComponent:@"Section.html"]]);
    XCTAssertTrue([fm fileExistsAtPath:[[dataStore pathForSectionId:35 title:title] stringByAppendingPathComponent:@"Section.plist"]]);
    XCTAssertTrue([fm fileExistsAtPath:[[dataStore pathForSectionId:35 title:title] stringByAppendingPathComponent:@"Section.html"]]);
}

@end
