//
//  MWKArticle.m
//  MediaWikiKit
//
//  Created by Brion on 10/7/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MediaWikiKit.h"

@implementation MWKArticle

-(instancetype)initWithTitle:(MWKPageTitle *)title dict:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        _title = title;
        _site = title.site;
        NSDictionary *mobileview = dict[@"mobileview"];
        if (mobileview) {
            NSString *redirected = mobileview[@"redirected"];
            _redirected = redirected; // may be null
            
            NSString *lastmodified = mobileview[@"lastmodified"];
            _lastmodified = [self getDateFromIso8601DateString:lastmodified];
            
            NSDictionary *user = mobileview[@"lastmodifiedby"];
            _lastmodifiedby = [_site userWithJSON:user];
            
            NSNumber *articleId = mobileview[@"id"];
            if (articleId) {
                _articleId = [articleId intValue];
            } else {
                _articleId = 0;
            }
            
            NSNumber *languagecount = mobileview[@"languagecount"];
            if (languagecount) {
                _languagecount = [languagecount intValue];
            } else {
                _languagecount = 0;
            }
            
            NSString *displaytitle = mobileview[@"displaytitle"];
            _displaytitle = displaytitle;
            
            // sections...
            
            NSObject *protection = mobileview[@"protection"];
            if ([protection isKindOfClass:[NSArray class]]) {
                // JSON formatting problems, sigh
                _protection = @{};
            } else if ([protection isKindOfClass:[NSDictionary class]]) {
                _protection = (NSDictionary *)protection;
            } else {
                // whaaaaat
            }
            
            NSNumber *editable = mobileview[@"editable"];
            if (editable) {
                _editable = [editable boolValue];
            }
        } else {
            // throw error
        }
    }
    return self;
}

- (NSDate *)getDateFromIso8601DateString:(NSString *)string
{
    // See: https://www.mediawiki.org/wiki/Manual:WfTimestamp
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    return  [formatter dateFromString:string];
}

@end
