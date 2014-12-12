//
//  MWKArticle.h
//  MediaWikiKit
//
//  Created by Brion on 10/7/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#pragma once

#import <UIKit/UIKit.h>

#import "MWKSiteDataObject.h"

@class MWKDataStore;
@class MWKSection;
@class MWKSectionList;
@class MWKImage;
@class MWKImageList;
@class MWKProtectionStatus;

@interface MWKArticle : MWKSiteDataObject

// Identifiers
@property (readonly) MWKSite *site;
@property (readonly) MWKTitle *title;
@property (readonly) MWKDataStore *dataStore;

// Metadata
@property (readonly) MWKTitle            *redirected;     // optional
@property (readonly) NSDate              *lastmodified;   // required
@property (readonly) MWKUser             *lastmodifiedby; // required
@property (readonly) int                  articleId;      // required; -> 'id'
@property (readonly) int                  languagecount;  // required; int
@property (readonly) NSString            *displaytitle;   // optional
@property (readonly) MWKProtectionStatus *protection;     // required
@property (readonly) BOOL                 editable;       // required

@property (readonly) NSString            *entitydescription; // optional; pulled via wikidata

@property (readonly) MWKSectionList *sections;

@property (readonly) MWKImageList *images;
-(MWKImage *)imageWithURL:(NSString *)url;
-(MWKImage *)largestImageWithURL:(NSString *)url;

@property (readwrite) MWKImage *thumbnail;
@property (readwrite) MWKImage *image;

@property (readwrite) BOOL needsRefresh;

-(instancetype)initWithTitle:(MWKTitle *)title dataStore:(MWKDataStore *)dataStore;
-(instancetype)initWithTitle:(MWKTitle *)title dataStore:(MWKDataStore *)dataStore dict:(NSDictionary *)dict;

/**
 * Import article and section metadata (and text if available)
 * from an API mobileview JSON response, save it to the database,
 * and make it available through this object.
 */
-(MWKArticle *)importMobileViewJSON:(NSDictionary *)jsonDict;

/**
 * Create a stub record for an image with given URL.
 */
-(MWKImage *)importImageURL:(NSString *)url sectionId:(int)sectionId;

/**
 * Import downloaded image data into our data store,
 * and update the image object/record
 */
-(MWKImage *)importImageData:(NSData *)data image:(MWKImage *)image mimeType:(NSString *)mimeType;

-(void)remove;


@end
