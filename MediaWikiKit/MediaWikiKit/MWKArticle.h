//
//  MWKArticle.h
//  MediaWikiKit
//
//  Created by Brion on 10/7/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWKArticle : NSObject

// Identifiers
@property NSString *site;
@property NSString *language;
@property MWKPageTitle *title;

// Metadata that could change
@property long articleId;

// Last-revision metadata
@property NSDate *lastmodified;
@property NSString *lastmodifiedby;
@property NSString *protectionStatus;
@property NSString *redirected;




@end
