//
//  MWKDataStore.m
//  MediaWikiKit
//
//  Created by Brion on 10/21/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MediaWikiKit.h"

@implementation MWKDataStore

-(instancetype)initWithBasePath:(NSString *)basePath
{
    self = [self init];
    if (self) {
        _basePath = [basePath copy];
    }
    return self;
}

-(NSString *)pathForPath:(NSString *)path
{
    return [self.basePath stringByAppendingPathComponent:path];
}

-(NSString *)pathForSites
{
    return [self pathForPath:@"sites"];
}

-(NSString *)pathForSite:(MWKSite *)site
{
    NSString *sitesPath = [self pathForSites];
    NSString *domainPath = [sitesPath stringByAppendingPathComponent:site.domain];
    return [domainPath stringByAppendingPathComponent:site.language];
}

-(NSString *)pathForArticlesWithSite:(MWKSite *)site
{
    NSString *sitePath = [self pathForSite:site];
    return [sitePath stringByAppendingPathComponent:@"articles"];
}

-(NSString *)pathForTitle:(MWKTitle *)title
{
    NSString *articlesPath = [self pathForArticlesWithSite:title.site];
    NSString *encTitle = [self safeFilenameWithString:title.prefixedDBKey];
    return [articlesPath stringByAppendingPathComponent:encTitle];
}

-(NSString *)pathForArticle:(MWKArticle *)article
{
    return [self pathForTitle:article.title];
}

-(NSString *)pathForSectionsWithTitle:(MWKTitle *)title
{
    NSString *articlePath = [self pathForTitle:title];
    return [articlePath stringByAppendingPathComponent:@"sections"];
}

-(NSString *)pathForSectionId:(int)sectionId title:(MWKTitle *)title
{
    NSString *sectionsPath = [self pathForSectionsWithTitle:title];
    NSString *sectionName = [NSString stringWithFormat:@"section%d", sectionId];
    return [sectionsPath stringByAppendingPathComponent:sectionName];
}

-(NSString *)pathForSection:(MWKSection *)section
{
    return [self pathForSectionId:section.sectionId title:section.title];
}

-(NSString *)safeFilenameWithString:(NSString *)str
{
    // This handy function does most of the percent-escaping
    NSString *encodedStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    // But it leaves "/" and "&" intact. Naughty!
    encodedStr = [encodedStr stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    encodedStr = [encodedStr stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];

    return encodedStr;
}

@end
