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

@interface MWKArticleFetcherTests : XCTestCase

@end

@implementation MWKArticleFetcherTests {
    MWKSite *site;
    MWKPageTitle *title;
    NSDictionary *json;
    MWKArticle *article;
}

- (void)setUp {
    [super setUp];

    site = [[MWKSite alloc] initWithDomain:@"en.wikipedia.org"];
    title = [site titleWithString:@"San Francisco"];
    
    NSDictionary *json = [self loadJSON:@"section0"];
    
    MWKArticle *article = [MWKArticleFetcher fetcherWithTitle:title];
    [article importJSON:json];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testFromJSON {
    XCTAssertNotNil(json, @"Loaded JSON");
    XCTAssertNotNil(article, "@Got an article");
    
}


- (NSDictionary *)loadJSON:(NSString *)name
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
    return dict;
}

@end
