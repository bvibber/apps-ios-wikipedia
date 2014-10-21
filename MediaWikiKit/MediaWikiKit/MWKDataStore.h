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

@interface MWKDataStore : NSObject

@property (readonly) NSString *basePath;

-(instancetype)initWithBasePath:(NSString *)basePath;

-(NSString *)pathForPath:(NSString *)path;
-(NSString *)pathForSites;
-(NSString *)pathForSite:(MWKSite *)site;
-(NSString *)pathForArticlesWithSite:(MWKSite *)site;
-(NSString *)pathForTitle:(MWKTitle *)title;
-(NSString *)pathForArticle:(MWKArticle *)article;
-(NSString *)pathForSectionsWithTitle:(MWKTitle *)title;
-(NSString *)pathForSection:(MWKSection *)section;

@end
