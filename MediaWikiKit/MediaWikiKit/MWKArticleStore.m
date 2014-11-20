//
//  MWKArticleFetcher.m
//  MediaWikiKit
//
//  Created by Brion on 10/7/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MediaWikiKit.h"

@implementation MWKArticleStore {
    MWKArticle *_article;
    NSArray *_sections;
}

-(instancetype)initWithTitle:(MWKTitle *)title dataStore:(MWKDataStore *)dataStore;
{
    self = [self init];
    if (self) {
        _title = title;
        _dataStore = dataStore;
        _article = nil;
        _sections = nil;
    }
    return self;
}

-(MWKArticle *)importMobileViewJSON:(NSDictionary *)dict
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
        [self.dataStore saveSection:section];
        if (sectionData[@"text"]) {
            [self.dataStore saveSectionText:sectionData[@"text"] section:section];
        }
    }
    _sections = [NSArray arrayWithArray:sections];

    [self.dataStore saveArticle:self.article];
    
    return self.article;
}

#pragma mark - getters

-(MWKArticle *)article
{
    if (!_article) {
        _article = [self.dataStore articleWithTitle:self.title];
    }
    return _article;
}
-(NSArray *)sections
{
    if (_sections) {
        return _sections;
    } else {
        @throw [NSException exceptionWithName:@"MWKArticleStoreException"
                                       reason:@"not yet implmemented sections loader"
                                     userInfo:@{}];
    }
}

-(MWKSection *)sectionAtIndex:(NSUInteger)index
{
    if (_sections) {
        return _sections[index];
    } else {
        return [self.dataStore sectionWithId:index article:self.article];
    }
}

-(NSString *)sectionTextAtIndex:(NSUInteger)index
{
    return [self.dataStore sectionTextWithId:index article:self.article];
}

-(NSArray *)imageURLs
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    // @fixme implement
    
    return [NSArray arrayWithArray:array];
}

-(MWKImage *)imageWithURL:(NSString *)url
{
    return [self.dataStore imageWithURL:url title:self.title];
}

-(MWKImage *)importImageURL:(NSString *)url
{
    return [[MWKImage alloc] initWithTitle:self.title sourceURL:url];
}

-(NSData *)imageDataWithImage:(MWKImage *)image
{
    return [self.dataStore imageDataWithImage:image];
}

-(MWKImage *)importImageData:(NSData *)data image:(MWKImage *)image mimeType:(NSString *)mimeType
{
    [self.dataStore saveImageData:data image:image mimeType:mimeType];
    return image;
}

@end
