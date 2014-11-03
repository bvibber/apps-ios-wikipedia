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
@class MWKTitle;
@class MWKDataStore;
@class MWKArticle;
@class MWKSection;
@class MWKImage;

@interface MWKArticleStore : NSObject

@property (readonly) MWKTitle *title;
@property (readonly) MWKDataStore *dataStore;

@property (readonly) MWKArticle *article;

@property (readonly) NSArray *sections; // ?
-(MWKSection *)sectionAtIndex:(int)index;

@property (readonly) NSArray *imageURLs;
-(MWKImage *)imageWithURL:(NSString *)url;
-(NSData *)imageDataWithImage:(MWKImage *)image;


-(instancetype)initWithTitle:(MWKTitle *)title dataStore:(MWKDataStore *)dataStore;

/**
 * Import article and section metadata (and text if available)
 * from an API mobileview JSON response, save it to the database,
 * and make it available through this object.
 */
-(void)importMobileViewJSON:(NSDictionary *)jsonDict;

/**
 * Import downloaded image data into our data store,
 * and update the image object/record
 */
-(void)importImageData:(NSData *)data image:(MWKImage *)image;


@end
