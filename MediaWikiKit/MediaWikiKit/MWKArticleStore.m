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
    MWKTitle *_title;
    MWKArticle *_article;
    NSArray *_sections;
}

-(instancetype)initWithTitle:(MWKTitle *)title;
{
    self = [self init];
    if (self) {
        _article = nil;
        _site = title.site;
        _title = title;
        _sections = nil;
    }
    return self;
}

-(void)importMobileViewJSON:(NSDictionary *)dict
{
    NSDictionary *mobileview = dict[@"mobileview"];
    if (!mobileview || ![mobileview isKindOfClass:[NSDictionary class]]) {
        @throw [NSException exceptionWithName:@"MWArticleStoreException"
                                       reason:@"invalid input, not a mobileview api data"
                                     userInfo:nil];
    }

    // Populate article metadata
    _article = [[MWKArticle alloc] initWithTitle:_title dict:mobileview];
    
    // Populate sections
    NSArray *sectionsData = mobileview[@"sections"];
    if (!sectionsData || ![sectionsData isKindOfClass:[NSArray class]]) {
        @throw [NSException exceptionWithName:@"MWArticleStoreException"
                                       reason:@"invalid input, sections missing or not an array"
                                     userInfo:nil];
    }
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:[sectionsData count]];
    for (NSDictionary *sectionData in sectionsData) {
        MWKSection *section = [[MWKSection alloc] initWithArticle:self.article dict:sectionData];
        [sections addObject:section];
    }
    _sections = [NSArray arrayWithArray:sections];

    [self saveArticle];
}

#pragma mark - io

-(void)saveArticle
{
    assert(self.article);
    NSDictionary *dict = [self.article dataExport];
}

#pragma mark - getters

-(NSArray *)sections
{
    return _sections;
}

-(MWKSection *)sectionAtIndex:(int)index
{
    return _sections[index];
}

-(NSString *)sectionTextAtIndex:(int)index
{
    return @"";
}

@end
