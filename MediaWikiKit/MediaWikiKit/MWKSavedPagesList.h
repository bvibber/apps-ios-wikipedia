//
//  MWKSavedPagesList.h
//  MediaWikiKit
//
//  Created by Brion on 11/3/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MWKDataObject.h"

@class MWKTitle;
@class MWKSavedPageEntry;

@interface MWKSavedPagesList : MWKDataObject

-(MWKSavedPageEntry *)entryForTitle:(MWKTitle *)title;
-(BOOL)isSaved:(MWKTitle *)title;

@end
