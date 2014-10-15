//
//  MWKArticleFetcherTests.m
//  MediaWikiKit
//
//  Created by Brion on 10/14/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MediaWikiKit.h"

@interface MWKArticleTests : XCTestCase

@end

@implementation MWKArticleTests {
    MWKSite *site;
    MWKTitle *title;
    NSDictionary *json;
    MWKArticle *article;
}

- (void)setUp {
    [super setUp];

    site = [[MWKSite alloc] initWithDomain:@"en.wikipedia.org"];
    title = [site titleWithString:@"San Francisco"];
    
    json = [self loadJSON:@"section0"];
    
    article = [[MWKArticle alloc] initWithTitle:title dict:json];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testFromJSON {
    XCTAssertNotNil(json, @"Loaded JSON");
    XCTAssertNotNil(article, @"Got an article");
}

- (void)testRequiredFieldsPresent {
    XCTAssertNotNil(article.lastmodified, @"lastmodified is required");
    XCTAssertNotNil(article.lastmodifiedby, @"lastmodifiedby is required");
}

- (void)testOptionalFieldsPresent {
    XCTAssertNil(article.redirected, @"redirected is empty");
    XCTAssertEqualObjects(article.displaytitle, @"San Francisco", @"displaytitle is present");
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
