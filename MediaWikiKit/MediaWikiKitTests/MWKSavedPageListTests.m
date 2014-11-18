//
//  MWKSavedPageListTests.m
//  MediaWikiKit
//
//  Created by Brion on 11/18/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MWKTestCase.h"

@interface MWKSavedPageListTests : MWKTestCase

@end

@implementation MWKSavedPageListTests{
    MWKSite *siteEn;
    MWKSite *siteFr;
    MWKTitle *titleSFEn;
    MWKTitle *titleLAEn;
    MWKTitle *titleSFFr;
    MWKSavedPageList *savedPageList;
}

- (void)setUp {
    [super setUp];
    
    siteEn = [[MWKSite alloc] initWithDomain:@"wikipedia.org" language:@"en"];
    siteFr = [[MWKSite alloc] initWithDomain:@"wikipedia.org" language:@"fr"];
    
    titleSFEn = [siteEn titleWithString:@"San Francisco"];
    titleLAEn = [siteEn titleWithString:@"Los Angeles"];
    titleSFFr = [siteFr titleWithString:@"San Francisco"];
    
    savedPageList = [[MWKSavedPageList alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testEmptyCount {
    XCTAssertEqual(savedPageList.length, 0, @"Should have length 0 initially");
}

- (void)testAddCount {
    MWKSavedPageEntry *entry = [[MWKSavedPageEntry alloc] initWithTitle:titleSFEn];
    [savedPageList addEntry:entry];
    XCTAssertEqual(savedPageList.length, 1, @"Should have length 1 after adding");
}

- (void)testAddCount2 {
    [savedPageList addEntry:[[MWKSavedPageEntry alloc] initWithTitle:titleSFEn]];
    [savedPageList addEntry:[[MWKSavedPageEntry alloc] initWithTitle:titleLAEn]];
    XCTAssertEqual(savedPageList.length, 2, @"Should have length 2 after adding");
}

- (void)testAddCount2Same {
    [savedPageList addEntry:[[MWKSavedPageEntry alloc] initWithTitle:titleSFEn]];
    [savedPageList addEntry:[[MWKSavedPageEntry alloc] initWithTitle:titleSFEn]];
    XCTAssertEqual(savedPageList.length, 1, @"Should have length 1 after adding a duplicate, not 2");
}

- (void)testAddCount2DiffLanguages {
    [savedPageList addEntry:[[MWKSavedPageEntry alloc] initWithTitle:titleSFEn]];
    [savedPageList addEntry:[[MWKSavedPageEntry alloc] initWithTitle:titleSFFr]];
    XCTAssertEqual(savedPageList.length, 2, @"Should have length 2 after adding a duplicate in another language, not 1");
}

- (void)testEmptyNotDirty {
    XCTAssertFalse(savedPageList.dirty, @"Should not be dirty initially");
}

- (void)testEmptyDirtyAfterAdd {
    [savedPageList addEntry:[[MWKSavedPageEntry alloc] initWithTitle:titleSFEn]];
    XCTAssertTrue(savedPageList.dirty, @"Should be dirty after adding");
}

- (void)testEmptyNotDirtyAfterAddAndSave {
    [savedPageList addEntry:[[MWKSavedPageEntry alloc] initWithTitle:titleSFEn]];
    (void)[savedPageList dataExport];
    XCTAssertFalse(savedPageList.dirty, @"Should not be dirty after adding then exporting");
}

- (void)testAdd2ThenRemove {
    MWKSavedPageEntry *entry1 = [[MWKSavedPageEntry alloc] initWithTitle:titleSFEn];
    MWKSavedPageEntry *entry2 = [[MWKSavedPageEntry alloc] initWithTitle:titleLAEn];
    [savedPageList addEntry:entry1];
    [savedPageList addEntry:entry2];
    [savedPageList removeEntry:entry1];
    XCTAssertEqual(savedPageList.length, 1, @"Should have length 1 after adding two then removing one");
}



@end
