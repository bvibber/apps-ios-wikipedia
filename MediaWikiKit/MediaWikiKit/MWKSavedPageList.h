//
//  MWKSavedPageList.h
//  MediaWikiKit
//
//  Created by Brion on 11/3/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MWKDataObject.h"

@class MWKTitle;
@class MWKSavedPageEntry;

@interface MWKSavedPageList : MWKDataObject

@property (readonly) NSUInteger length;

-(MWKSavedPageEntry *)entryAtIndex:(NSUInteger)index;
-(int)indexForEntry:(MWKSavedPageEntry *)entry;

-(MWKSavedPageEntry *)entryForTitle:(MWKTitle *)title;
-(BOOL)isSaved:(MWKTitle *)title;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
