//
//  MWArticleStoreTests.m
//  MediaWikiKit
//
//  Created by Brion on 10/21/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MediaWikiKit.h"

@interface MWArticleStoreTests : XCTestCase

@end

@implementation MWArticleStoreTests {
    MWKSite *site;
    MWKTitle *title;
    NSDictionary *json0;
    NSDictionary *json1;
    MWKArticleStore *store;
    MWKArticle *rawArticle;
}

- (void)setUp {
    [super setUp];
    
    site = [[MWKSite alloc] initWithDomain:@"wikipedia.org" language:@"en"];
    title = [site titleWithString:@"San Francisco"];
    
    json0 = [self loadJSON:@"section0"];
    json1 = [self loadJSON:@"section1-end"];
    rawArticle = [[MWKArticle alloc] initWithTitle:title dict:json0[@"mobileview"]];

    store = [[MWKArticleStore alloc] initWithTitle:title];
    [store importMobileViewJSON:json0];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testArticle
{
    
    XCTAssertEqualObjects(store.article, rawArticle);
}

- (void)testSectionCount
{
    XCTAssertEqual([store.sections count], 36);
}

- (void)testSectionAtIndex
{
    NSArray *sections = store.sections;
    for (int i = 0; i < [sections count]; i++) {
        MWKSection *section0 = sections[i];
        MWKSection *section1 = [store sectionAtIndex:i];
        XCTAssertEqual(section0, section1);
    }
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
