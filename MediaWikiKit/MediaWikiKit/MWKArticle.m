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
    self = [self initWithSite:title.site];
    if (self) {
        _title = title;
        NSDictionary *mobileview = dict[@"mobileview"];
        if (mobileview) {
            _redirected     = [self optionalTitle:     @"redirected"     dict:mobileview];
            _lastmodified   = [self requiredDate:      @"lastmodified"   dict:mobileview];
            _lastmodifiedby = [self requiredUser:      @"lastmodifiedby" dict:mobileview];
            _articleId      = [self requiredNumber:    @"id"             dict:mobileview];
            _languagecount  = [self requiredNumber:    @"languagecount"  dict:mobileview];
            _displaytitle   = [self optionalString:    @"displaytitle"   dict:mobileview];
            _protection     = [self requiredDictionary:@"protection"     dict:mobileview];
            _editable       = [self requiredNumber:    @"editable"       dict:mobileview];
        } else {
            // throw error
        }
    }
    return self;
}

@end
