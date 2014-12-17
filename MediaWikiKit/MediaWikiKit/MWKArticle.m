//
//  MWKArticle.m
//  MediaWikiKit
//
//  Created by Brion on 10/7/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MediaWikiKit.h"

@implementation MWKArticle

-(instancetype)initWithTitle:(MWKTitle *)title dataStore:(MWKDataStore *)dataStore
{
    self = [self initWithSite:title.site];
    if (self) {
        _dataStore = dataStore;
        _title = title;
    }
    return self;
}

-(instancetype)initWithTitle:(MWKTitle *)title dataStore:(MWKDataStore *)dataStore dict:(NSDictionary *)dict
{
    self = [self initWithTitle:title dataStore:dataStore];
    if (self) {
        [self importMobileViewJSON:dict];
    }
    return self;
}

-(id)dataExport
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    if (self.redirected) {
        dict[@"redirected"] = self.redirected.prefixedText;
    }
    dict[@"lastmodified"] = [self iso8601DateString:self.lastmodified];
    if (!self.lastmodifiedby.anonymous) {
        dict[@"lastmodifiedby"] = [self.lastmodifiedby dataExport];
    }
    dict[@"id"] = @(self.articleId);
    dict[@"languagecount"] = @(self.languagecount);
    if (self.displaytitle) {
        dict[@"displaytitle"] = self.displaytitle;
    }
    dict[@"protection"] = [self.protection dataExport];
    dict[@"editable"] = @(self.editable);

    if (self.entitydescription) {
        // This doesn't come from mobileview api, queried separately
        dict[@"entitydescription"] = self.entitydescription;
    }

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [self dataExport]];
}

- (BOOL)isEqual:(id)object
{
    if (object == nil) {
        return NO;
    } else if (![object isKindOfClass:[MWKArticle class]]) {
        return NO;
    } else {
        MWKArticle *other = object;
        return [self.site isEqual:other.site] &&
            (self.redirected == other.redirected || [self.redirected isEqual:other.redirected]) &&
            [self.lastmodified isEqual:other.lastmodified] &&
            [self.lastmodifiedby isEqual:other.lastmodifiedby] &&
            self.articleId == other.articleId &&
            self.languagecount == other.languagecount &&
            [self.displaytitle isEqualToString:other.displaytitle] &&
            [self.protection isEqual:other.protection] &&
            self.editable == other.editable;
        
    }
}


-(void)importMobileViewJSON:(NSDictionary *)dict
{
    _redirected     =  [self optionalTitle:           @"redirected"     dict:dict];
    _lastmodified   =  [self requiredDate:            @"lastmodified"   dict:dict];
    _lastmodifiedby =  [self requiredUser:            @"lastmodifiedby" dict:dict];
    _articleId      = [[self requiredNumber:          @"id"             dict:dict] intValue];
    _languagecount  = [[self requiredNumber:          @"languagecount"  dict:dict] intValue];
    _displaytitle   =  [self optionalString:          @"displaytitle"   dict:dict];
    _protection     =  [self requiredProtectionStatus:@"protection"     dict:dict];
    _editable       = [[self requiredNumber:          @"editable"       dict:dict] boolValue];
    
    // This doesn't come from mobileview api, queried separately
    _entitydescription = [self optionalString:        @"entitydescription" dict:dict];

    
    [self.dataStore saveArticle:self];
    // @fixme should this save here or mark as dirty somehow?

    // Populate sections
    NSArray *sectionsData = dict[@"sections"];
    if (!sectionsData || ![sectionsData isKindOfClass:[NSArray class]]) {
        @throw [NSException exceptionWithName:@"MWArticleStoreException"
                                       reason:@"invalid input, sections missing or not an array"
                                     userInfo:nil];
    }
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:[sectionsData count]];
    for (NSDictionary *sectionData in sectionsData) {
        MWKSection *section = [[MWKSection alloc] initWithArticle:self dict:sectionData];
        [sections addObject:section];
        [self.dataStore saveSection:section];
        if (sectionData[@"text"]) {
            [self.dataStore saveSectionText:sectionData[@"text"] section:section];
        }
    }
}


/**
 * Create a stub record for an image with given URL.
 */
-(MWKImage *)importImageURL:(NSString *)url sectionId:(int)sectionId
{
    [self.sections[sectionId].images addImageURL:url];
    return [[MWKImage alloc] initWithArticle:self sourceURL:url];
}

/**
 * Import downloaded image data into our data store,
 * and update the image object/record
 */
-(MWKImage *)importImageData:(NSData *)data image:(MWKImage *)image mimeType:(NSString *)mimeType
{
    [self.dataStore saveImageData:data image:image mimeType:mimeType];
    return image;
}

-(MWKImage *)imageWithURL:(NSString *)url
{
    return [self.dataStore imageWithURL:url article:self];
}

-(void)setNeedsRefresh:(BOOL)val
{
    NSString *payload = @"needsRefresh";
    NSString *filePath = [self.dataStore pathForArticle:self];
    NSString *fileName = [filePath stringByAppendingPathComponent:@"needsRefresh.lock"];
    [payload writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(BOOL)needsRefresh
{
    NSString *filePath = [self.dataStore pathForArticle:self];
    NSString *fileName = [filePath stringByAppendingPathComponent:@"needsRefresh.lock"];
    return [[NSFileManager defaultManager] fileExistsAtPath:fileName isDirectory:nil];
}

-(void)remove
{
    NSString *path = [self.dataStore pathForArticle:self];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}


#pragma mark - protection status methods

-(MWKProtectionStatus *)requiredProtectionStatus:(NSString *)key dict:(NSDictionary *)dict
{
    NSDictionary *obj = [self requiredDictionary:key dict:dict];
    if (obj == nil) {
        @throw [NSException exceptionWithName:@"MWKDataObjectException"
                                       reason:@"missing required protection status field"
                                     userInfo:@{@"key": key}];
    } else {
        return [[MWKProtectionStatus alloc] initWithData:obj];
    }
}

@end
