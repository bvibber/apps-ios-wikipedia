//
//  MWKSavedPageStore.h
//  MediaWikiKit
//
//  Created by Brion on 11/10/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MWKDataStore;
@class MWKTitle;

@interface MWKSavedPageStore : NSObject

@property (readonly) MWKDataStore *dataStore;
-(instancetype)initWithDataStore:(MWKDataStore *)dataStore;


-(BOOL)isPageSaved:(MWKTitle *)title;
-(void)savePage:(MWKTitle *)title;

@end
