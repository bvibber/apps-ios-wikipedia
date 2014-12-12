//
//  MWKImageList.h
//  MediaWikiKit
//
//  Created by Brion on 12/3/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MWKSiteDataObject.h"

@class MWKImage;

@interface MWKImageList : MWKSiteDataObject
@property (weak, readonly) MWKArticle *article;

@property (readonly) NSUInteger length;

-(instancetype)initWithArticle:(MWKArticle *)article;
-(instancetype)initWithArticle:(MWKArticle *)article dict:(NSDictionary *)dict;

-(void)addImageURL:(NSString *)imageURL;

-(BOOL)hasImageURL:(NSString *)imageURL;
-(NSString *)largestImageVariant:(NSString *)image;

@property (readonly) BOOL dirty;

-(NSString *)imageURLAtIndex:(NSUInteger)index;
-(MWKImage *)objectAtIndexedSubscript:(NSUInteger)index;

@end
