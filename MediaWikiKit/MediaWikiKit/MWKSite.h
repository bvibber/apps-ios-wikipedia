//  Created by Brion on 11/6/13.
//  Copyright (c) 2013 Wikimedia Foundation. Provided under MIT-style license; please copy and modify!

#import <Foundation/Foundation.h>
#import "MWKPageTitle.h"

@interface MWKSite : NSObject

@property NSString *domain;

- (instancetype)initWithDomain:(NSString *)domain;
- (MWKPageTitle *)titleForInternalLink:(NSString *)path;

@end
