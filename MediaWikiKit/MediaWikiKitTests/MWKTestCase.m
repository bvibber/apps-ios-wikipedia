//
//  MWKTestCase.m
//  MediaWikiKit
//
//  Created by Brion on 10/21/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MWKTestCase.h"

@implementation MWKTestCase

- (id)loadJSON:(NSString *)name
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *err = nil;
    id dictOrArray = [NSJSONSerialization JSONObjectWithData:data options:nil error:&err];
    assert(err == nil);
    assert(dictOrArray);
    return dictOrArray;
}

@end
