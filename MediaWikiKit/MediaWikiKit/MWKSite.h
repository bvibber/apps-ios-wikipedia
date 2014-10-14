//  Created by Brion on 11/6/13.
//  Copyright (c) 2013 Wikimedia Foundation. Provided under MIT-style license; please copy and modify!

#pragma once

#import <Foundation/Foundation.h>

// forward decl
@class MWKPageTitle;
@class MWKUser;

@interface MWKSite : NSObject

@property NSString *domain;

- (instancetype)initWithDomain:(NSString *)domain;

- (MWKPageTitle *)titleWithString:(NSString *)string;
- (MWKPageTitle *)titleWithInternalLink:(NSString *)path;

- (MWKUser *)userWithName:(NSString *)name gender:(NSString *)gender;
- (MWKUser *)userWithAnonymous;
- (MWKUser *)userWithJSON:(NSDictionary *)dict;

@end
