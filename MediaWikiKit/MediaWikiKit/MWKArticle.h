//
//  MWKArticle.h
//  MediaWikiKit
//
//  Created by Brion on 10/7/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>

// forward decls
@class MWKSite;
@class MWKPageTitle;
@class MWKUser;
@class MWKSection;

@interface MWKArticle : NSObject

// Identifiers
@property (readonly) MWKSite *site;
@property (readonly) MWKPageTitle *title;

// Metadata
@property (readonly) NSString *redirected; // may be nil. should this be a title as well?
@property (readonly) NSDate *lastmodified;
@property (readonly) MWKUser *lastmodifiedby;
@property (readonly) int articleId; // -> 'id'
@property (readonly) int languagecount;
@property (readonly) NSString *displaytitle;
@property (readonly) NSDictionary *protection;
@property (readonly) bool editable;

-(instancetype)initWithTitle:(MWKPageTitle *)title dict:(NSDictionary *)dict;

@end
