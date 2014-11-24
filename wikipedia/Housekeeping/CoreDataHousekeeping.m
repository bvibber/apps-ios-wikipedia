//  Created by Monte Hurd on 6/18/14.
//  Copyright (c) 2014 Wikimedia Foundation. Provided under MIT-style license; please copy and modify!

#import "CoreDataHousekeeping.h"
#import "NSDate-Utilities.h"

@interface CoreDataHousekeeping (){
    //NSManagedObjectContext *context_;
}

@end

@implementation CoreDataHousekeeping

- (instancetype)init
{
    self = [super init];
    if (self) {
        //context_ = [ArticleDataContextSingleton sharedInstance].mainContext;
    }
    return self;
}

-(void)performHouseKeeping
{}

-(void)removeUnsavedUnhistoriedArticles
{
}

-(void)removeUnsavedArticleSections
{}

-(void)removeUnusedImages
{
}

@end
