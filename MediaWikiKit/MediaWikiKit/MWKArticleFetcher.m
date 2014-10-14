//
//  MWKArticleFetcher.m
//  MediaWikiKit
//
//  Created by Brion on 10/7/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MediaWikiKit.h"

@implementation MWKArticleFetcher {
    MWKSite *_site;
    MWKPageTitle *_title;
}

-(instancetype)initWithTitle:(MWKPageTitle *)title;
{
    self = [self init];
    if (self) {
        _article = nil;
        _site = title.site;
        _title = title;
    }
    return self;
}

-(void)importJSON:(NSDictionary *)dict
{
    [[MWKArticle alloc] initWithTitle:_title dict:dict];
}

@end
