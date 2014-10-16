//  Created by Brion on 11/6/13.
//  Copyright (c) 2013 Wikimedia Foundation. Provided under MIT-style license; please copy and modify!

#import "MediaWikiKit.h"

@implementation MWKSite

- (instancetype)initWithDomain:(NSString *)domain
{
    self = [super init];
    if (self) {
        self.domain = domain;
    }
    return self;
}

- (BOOL)isEqual:(id)other
{
    if (other == nil) {
        return NO;
    }
    if (![other isKindOfClass:self.class]) {
        return NO;
    }
    MWKSite *otherSite = other;
    return [self.domain isEqualToString:otherSite.domain];
}


#pragma mark - Title methods

- (MWKTitle *)titleWithString:(NSString *)string
{
    return [MWKTitle titleWithString:string site:self];
}

static NSString *localLinkPrefix = @"/wiki/";

- (MWKTitle *)titleWithInternalLink:(NSString *)path
{
    if ([path hasPrefix:localLinkPrefix]) {
        NSString *remainder = [path substringFromIndex:localLinkPrefix.length];
        return [self titleWithString:remainder];
    } else {
        @throw [NSException exceptionWithName:@"SiteBadLinkFormatException" reason:@"unexpected local link format" userInfo:nil];
    }
}

@end
