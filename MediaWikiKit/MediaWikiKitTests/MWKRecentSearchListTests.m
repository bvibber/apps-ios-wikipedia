//
//  MWKRecentSearchListTests.m
//  MediaWikiKit
//
//  Created by Brion on 11/18/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MWKTestCase.h"

@interface MWKRecentSearchListTests : MWKTestCase

@end

@implementation MWKRecentSearchListTests{
    MWKSite *siteEn;
    MWKSite *siteFr;
    NSString *sf;
    NSString *la;
    MWKRecentSearchList *searchList;
}

- (void)setUp {
    [super setUp];
    
    siteEn = [[MWKSite alloc] initWithDomain:@"wikipedia.org" language:@"en"];
    siteFr = [[MWKSite alloc] initWithDomain:@"wikipedia.org" language:@"fr"];
    
    sf = @"San Francisco";
    la = @"Los Angeles";
    
    searchList = [[MWKRecentSearchList alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testEmptyCount {
    XCTAssertEqual(searchList.length, 0, @"Should have length 0 initially");
}

- (void)testAddCount {
    MWKRecentSearchEntry *entry = [[MWKRecentSearchEntry alloc] initWithSite:siteEn searchTerm:sf];
    [searchList addEntry:entry];
    XCTAssertEqual(searchList.length, 1, @"Should have length 1 after adding");
}

- (void)testAddCount2 {
    [searchList addEntry:[[MWKRecentSearchEntry alloc] initWithSite:siteEn searchTerm:sf]];
    [searchList addEntry:[[MWKRecentSearchEntry alloc] initWithSite:siteEn searchTerm:la]];
    XCTAssertEqual(searchList.length, 2, @"Should have length 2 after adding");
}

- (void)testAddCount2Same {
    [searchList addEntry:[[MWKRecentSearchEntry alloc] initWithSite:siteEn searchTerm:sf]];
    [searchList addEntry:[[MWKRecentSearchEntry alloc] initWithSite:siteEn searchTerm:sf]];
    XCTAssertEqual(searchList.length, 1, @"Should have length 1 after adding a duplicate, not 2");
}

- (void)testAddCount2DiffLanguages {
    [searchList addEntry:[[MWKRecentSearchEntry alloc] initWithSite:siteEn searchTerm:sf]];
    [searchList addEntry:[[MWKRecentSearchEntry alloc] initWithSite:siteFr searchTerm:sf]];
    XCTAssertEqual(searchList.length, 2, @"Should have length 2 after adding a duplicate in another language, not 1");
}

- (void)testEmptyNotDirty {
    XCTAssertFalse(searchList.dirty, @"Should not be dirty initially");
}

- (void)testEmptyDirtyAfterAdd {
    [searchList addEntry:[[MWKRecentSearchEntry alloc] initWithSite:siteEn searchTerm:sf]];
    XCTAssertTrue(searchList.dirty, @"Should be dirty after adding");
}

- (void)testEmptyNotDirtyAfterAddAndSave {
    [searchList addEntry:[[MWKRecentSearchEntry alloc] initWithSite:siteEn searchTerm:sf]];
    (void)[searchList dataExport];
    XCTAssertFalse(searchList.dirty, @"Should not be dirty after adding then exporting");
}

- (void)testAdd2ThenRemove {
    MWKRecentSearchEntry *entry1 = [[MWKRecentSearchEntry alloc] initWithSite:siteEn searchTerm:sf];
    MWKRecentSearchEntry *entry2 = [[MWKRecentSearchEntry alloc] initWithSite:siteEn searchTerm:la];
    [searchList addEntry:entry1];
    [searchList addEntry:entry2];
    [searchList removeEntry:entry1];
    XCTAssertEqual(searchList.length, 1, @"Should have length 1 after adding two then removing one");
}

@end
