//
//  MWKArticleFetcher.h
//  MediaWikiKit
//
//  Created by Brion on 10/7/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>

// Forward decls
@class MWKPageTitle;
@class MWKArticle;
@class MWKSection;

@interface MWKArticleStore : NSObject

@property (readonly) MWKArticle *article;
@property (readonly) NSArray *sections;
-(MWKSection *)sectionAtIndex:(int)index;

-(instancetype)initWithTitle:(MWKPageTitle *)title;

-(void)importMobileViewJSON:(NSDictionary *)jsonDict;


@end
