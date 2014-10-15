//
//  MWKArticle.h
//  MediaWikiKit
//
//  Created by Brion on 10/7/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>

#include "MWKDataObject.h"

// forward decls
@class MWKSite;
@class MWKTitle;
@class MWKUser;
@class MWKSection;

@interface MWKArticle : MWKDataObject

// Identifiers
@property (readonly) MWKSite *site;
@property (readonly) MWKTitle *title;

// Metadata
@property (readonly) MWKTitle *redirected;     // optional
@property (readonly) NSDate       *lastmodified;   // required
@property (readonly) MWKUser      *lastmodifiedby; // required
@property (readonly) int           articleId;      // required; -> 'id'
@property (readonly) int           languagecount;  // required; int
@property (readonly) NSString     *displaytitle;   // optional
@property (readonly) NSDictionary *protection;     // required
@property (readonly) BOOL          editable;       // required

-(instancetype)initWithTitle:(MWKTitle *)title dict:(NSDictionary *)dict;

@end
