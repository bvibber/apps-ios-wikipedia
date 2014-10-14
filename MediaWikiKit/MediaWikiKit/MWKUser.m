//
//  MWKUser.m
//  MediaWikiKit
//
//  Created by Brion on 10/14/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MediaWikiKit.h"

@implementation MWKUser

-(instancetype)initWithSite:(MWKSite *)site name:(NSString *)name gender:(NSString *)gender
{
    self = [self init];
    if (self) {
        _site = site;
        _anonymous = NO;
        _name = [name copy];
        _gender = [gender copy];
    }
    return self;
}

-(instancetype)initWithSite:(MWKSite *)site anonymous:(BOOL)anonymous
{
    self = [self init];
    if (self) {
        assert(anonymous);
        _site = site;
        _anonymous = anonymous;
        _name = nil;
        _gender = nil;
    }
    return self;
}

@end
