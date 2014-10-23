//
//  MWKDataStore.h
//  MediaWikiKit
//
//  Created by Brion on 10/21/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MWKSite;
@class MWKTitle;
@class MWKArticle;
@class MWKSection;
@class MWKArticleStore;

@interface MWKDataStore : NSObject

@property (readonly) NSString *basePath;

-(instancetype)initWithBasePath:(NSString *)basePath;

// Path methods
-(NSString *)pathForPath:(NSString *)path;
-(NSString *)pathForSites;
-(NSString *)pathForSite:(MWKSite *)site;
-(NSString *)pathForArticlesWithSite:(MWKSite *)site;
-(NSString *)pathForTitle:(MWKTitle *)title;
-(NSString *)pathForArticle:(MWKArticle *)article;
-(NSString *)pathForSectionsWithTitle:(MWKTitle *)title;
-(NSString *)pathForSectionId:(int)sectionId title:(MWKTitle *)title;
-(NSString *)pathForSection:(MWKSection *)section;

// Raw save methods
-(void)saveArticle:(MWKArticle *)article;
-(void)saveSection:(MWKSection *)section;
-(void)saveSectionText:(NSString *)html section:(MWKSection *)section;

// Raw load methods
-(MWKArticle *)articleWithTitle:(MWKTitle *)title;
-(MWKSection *)sectionWithId:(int)sectionId article:(MWKArticle *)article;
-(NSString *)sectionTextWithId:(int)sectionId article:(MWKArticle *)article;

// Storage helper methods
-(MWKArticleStore *)articleStoreWithTitle:(MWKTitle *)title;

@end
