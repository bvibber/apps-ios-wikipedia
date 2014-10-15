//
//  MWKArticleFetcher.m
//  MediaWikiKit
//
//  Created by Brion on 10/7/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MediaWikiKit.h"

@implementation MWKArticleStore {
    MWKSite *_site;
    MWKPageTitle *_title;
    MWKArticle *_article;
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

-(void)importMobileViewJSON:(NSDictionary *)dict
{
    _article = [[MWKArticle alloc] initWithTitle:_title dict:dict];
}

#pragma mark - io

#pragma mark - getters

-(NSArray *)sections
{
    return @[];
}

-(MWKSection *)sectionAtIndex:(int)index
{
    return nil;
}

-(NSString *)sectionTextAtIndex:(int)index
{
    return @"";
}

@end
