//  Created by Brion on 11/6/13.
//  Copyright (c) 2013 Wikimedia Foundation. Provided under MIT-style license; please copy and modify!

#pragma once

#import <Foundation/Foundation.h>

// forward decl
@class MWKTitle;
@class MWKUser;

@interface MWKSite : NSObject

@property NSString *domain;

- (instancetype)initWithDomain:(NSString *)domain;

- (MWKTitle *)titleWithString:(NSString *)string;
- (MWKTitle *)titleWithInternalLink:(NSString *)path;

@end
