//
//  MWKSiteTests.m
//  MediaWikiKit
//
//  Created by Brion on 10/7/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MediaWikiKit.h"

@interface MWKSiteTests : XCTestCase

@end

@implementation MWKSiteTests {
    MWKSite *site;
}

- (void)setUp {
    [super setUp];
    site = [[MWKSite alloc] initWithDomain:@"en.wikipedia.org"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDomain
{
    XCTAssertEqualObjects(site.domain, @"en.wikipedia.org");
}

- (void)testEquals
{
    MWKSite *otherSite = [[MWKSite alloc] initWithDomain:@"en.wikipedia.org"];
    XCTAssertEqualObjects(site, otherSite);
}

- (void)testLinks
{
    XCTAssertEqualObjects([site titleForInternalLink:@"/wiki/India"].prefixedText, @"India");
    XCTAssertEqualObjects([site titleForInternalLink:@"/wiki/Talk:India"].prefixedText, @"Talk:India");
    XCTAssertEqualObjects([site titleForInternalLink:@"/wiki/Talk:India#History"].prefixedText, @"Talk:India");
    //    XCTAssertThrows([site titleForInternalLink:@"/upload/foobar"]);
}

@end
