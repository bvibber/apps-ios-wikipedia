//
//  OldDataSchema.m
//  OldDataSchema
//
//  Created by Brion on 12/22/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "OldDataSchema.h"

#import "ArticleDataContextSingleton.h"
#import "ArticleCoreDataObjects.h"
#import "NSManagedObjectContext+SimpleFetch.h"

@implementation OldDataSchema {
    ArticleDataContextSingleton *context;
}

-(BOOL)exists
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentRootPath = [documentPaths objectAtIndex:0];
    NSString *filePath = [documentRootPath stringByAppendingPathComponent:@"articleData6.sqlite"];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

-(void)migrateData
{
    // TODO
}

-(void)migrateArticle:(Article *)article
{
    NSDictionary *dict = [self exportArticle:article];
    [self.delegate oldDataSchema:self migrateHistoryEntry:dict];
}

-(NSDictionary *)exportArticle:(Article *)article
{
    NSMutableDictionary *dict = [@{} mutableCopy];
    
    dict[@"redirected"] = // optional
    dict[@"lastmodified"] = // date
    dict[@"lastmodifiedby"] = // dict structure for user or empty
    dict[@"id"] = // number
    dict[@"languagecount"] = // number
    dict[@"displaytitle"] = // optional
    dict[@"protection"] = // struct
    dict[@"editable"] = // boolean
    
    // sections!
    dict[@"sections"] = [@[] mutableCopy];
    for (Section *section in article.section) {
        int sectionId = [section.sectionId intValue];
        dict[@"sections"][sectionId] = [self exportSection:section];
    }
    
    return @{
             @"language": article.domain,
             @"title": article.title,
             @"dict": dict
             };
}

-(NSDictionary *)exportSection:(Section *)section
{
    NSMutableDictionary *dict = [@{} mutableCopy];
    
    if (section.tocLevel) {
        dict[@"toclevel"] = section.tocLevel;
    }
    if (section.level) {
        dict[@"level"] = section.level;
    }
    if (section.title) {
        dict[@"line"] = section.title;
    }
    if (section.fromTitle) {
        dict[@"fromtitle"] = section.fromTitle;
    }
    if (section.anchor) {
        dict[@"anchor"] = section.anchor;
    }
    dict[@"id"] = section.sectionId;
    if (section.html) {
        dict[@"text"] = section.html;
    }
    
    return dict;
}

@end
