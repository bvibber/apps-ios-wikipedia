//
//  MWKImageList.m
//  MediaWikiKit
//
//  Created by Brion on 12/3/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MediaWikiKit.h"

@implementation MWKImageList {
    NSMutableArray *entries;
    NSMutableDictionary *entriesByURL;
    NSMutableDictionary *entriesByNameWithoutSize;
    unsigned long mutationState;
}

-(void)addImageURL:(NSString *)imageURL
{
    [entries addObject:imageURL];
    entriesByURL[imageURL] = imageURL;
    
    NSString *key = [MWKImage fileNameNoSizePrefix:imageURL];
    NSMutableArray *byname = entriesByNameWithoutSize[key];
    if (byname == nil) {
        byname = [[NSMutableArray alloc] init];
        entriesByNameWithoutSize[key] = byname;
    }
    [byname addObject:imageURL];
    mutationState++;
}

-(NSUInteger)count
{
    return [entries count];
}

-(NSString *)imageURLAtIndex:(NSUInteger)index
{
    if (index < [entries count]) {
        return entries[index];
    } else {
        return nil;
    }
}

-(MWKImage *)objectAtIndexedSubscript:(NSUInteger)index
{
    NSString *imageURL = [self imageURLAtIndex:index];
    return [self.section.article.dataStore imageWithURL:imageURL title:self.section.article.title];
}

-(BOOL)hasImageURL:(NSString *)imageURL
{
    return (entriesByURL[imageURL] != nil);
}

-(NSString *)largestImageVariant:(NSString *)imageURL
{
    NSString *baseName = [MWKImage fileNameNoSizePrefix:imageURL];
    NSMutableArray *arr = entriesByNameWithoutSize[baseName];
    
    int width = -1, biggestWidth = -1;
    NSString *biggestURL = imageURL;
    if (arr) {
        for (NSString *sourceURL in arr) {
            NSString *fileName = [sourceURL lastPathComponent];
            width = [MWKImage fileSizePrefix:fileName];
            NSLog(@"%@ is %d", fileName, width);
            if (width > biggestWidth) {
                biggestWidth = width;
                biggestURL = sourceURL;
            }
        }
    } else {
        NSLog(@"no variants for %@", baseName);
    }
    return biggestURL;
}


#pragma mark - data i/o

-(instancetype)initWithSection:(MWKSection *)section
{
    self = [self initWithSite:section.site];
    if (self) {
        _section = section;
        mutationState = 0;
        entriesByURL = [[NSMutableDictionary alloc] init];
        entriesByNameWithoutSize = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(instancetype)initWithSection:(MWKSection *)section dict:(NSDictionary *)dict
{
    self = [self initWithSection:section];
    if (self) {
        for (NSString *url in dict[@"entries"]) {
            [self addImageURL:url];
        }
    }
    return self;
}

-(id)dataExport
{
    return @{@"entries": entries};
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(__unsafe_unretained id [])stackbuf
                                    count:(NSUInteger)len
{
    NSUInteger start = state->state,
        count = 0;
    
    for (NSUInteger i = 0; i < len && start + count < [self count]; i++) {
        stackbuf[i] = self[i + start];
        count++;
    }
    state->state += count;
    
    state->itemsPtr = stackbuf;
    state->mutationsPtr = &mutationState;

    return count;
}

@end
