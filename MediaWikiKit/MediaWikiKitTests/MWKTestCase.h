//
//  MWKTestCase.h
//  MediaWikiKit
//
//  Created by Brion on 10/21/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MediaWikiKit.h"

@interface MWKTestCase : XCTestCase

- (id)loadJSON:(NSString *)name;

@end
