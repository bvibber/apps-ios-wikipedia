//  Created by Brion on 11/1/13.
//  Copyright (c) 2013 Wikimedia Foundation. Provided under MIT-style license; please copy and modify!

#import "MediaWikiKit.h"

@implementation MWKTitle {
    MWKSite *_site;
    NSString *_text;
    NSString *_fragment;
}

#pragma mark - Class methods

+(MWKTitle *)titleWithString:(NSString *)str site:(MWKSite *)site
{
    return [[MWKTitle alloc] initWithString:str site:site];
}

+(NSString *)normalize:(NSString *)str
{
    // @todo implement fuller normalization?
    return [str stringByReplacingOccurrencesOfString:@"_" withString:@" "];
}

#pragma mark - Initializers

-(instancetype)initWithString:(NSString *)str site:(MWKSite *)site
{
    self = [self init];
    if (self) {
        _site = site;
        NSArray *bits = [str componentsSeparatedByString:@"#"];
        _text = [MWKTitle normalize:bits[0]];
        if (bits.count > 1) {
            _fragment = bits[1];
        } else {
            _fragment = nil;
        }
    }
    return self;
}

#pragma mark - Property getters

-(MWKSite *)site
{
    return _site;
}

-(NSString *)namespace
{
    // @todo implement namespace detection and normalization
    // doing this right requires some site info
    return nil;
}

-(NSString *)text
{
    return _text;
}

-(NSString *)fragment
{
    return _fragment;
}

-(NSString *)_prefix
{
    // @todo implement namespace prefixing once namespaces are handled
    return @"";
}

-(NSString *)prefixedText
{
    return [[self _prefix] stringByAppendingString:self.text];
}

-(NSString *)prefixedDBKey
{
    return [self.prefixedText stringByReplacingOccurrencesOfString:@" " withString:@"_"];
}

-(NSString *)prefixedURL
{
    return [self.prefixedDBKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(NSString *)fragmentForURL
{
    if (self.fragment) {
        // @fixme we use some weird escaping system...?
        return [@"#" stringByAppendingString:[self.fragment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    } else {
        return @"";
    }
}

@end
