//
//  MWKDataStore.m
//  MediaWikiKit
//
//  Created by Brion on 10/21/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MediaWikiKit.h"

@implementation MWKDataStore

-(instancetype)initWithBasePath:(NSString *)basePath
{
    self = [self init];
    if (self) {
        _basePath = [basePath copy];
    }
    return self;
}

#pragma mark - path methods

-(NSString *)pathForPath:(NSString *)path
{
    return [self.basePath stringByAppendingPathComponent:path];
}

-(NSString *)pathForSites
{
    return [self pathForPath:@"sites"];
}

-(NSString *)pathForSite:(MWKSite *)site
{
    NSString *sitesPath = [self pathForSites];
    NSString *domainPath = [sitesPath stringByAppendingPathComponent:site.domain];
    return [domainPath stringByAppendingPathComponent:site.language];
}

-(NSString *)pathForArticlesWithSite:(MWKSite *)site
{
    NSString *sitePath = [self pathForSite:site];
    return [sitePath stringByAppendingPathComponent:@"articles"];
}

-(NSString *)pathForTitle:(MWKTitle *)title
{
    NSString *articlesPath = [self pathForArticlesWithSite:title.site];
    NSString *encTitle = [self safeFilenameWithString:title.prefixedDBKey];
    return [articlesPath stringByAppendingPathComponent:encTitle];
}

-(NSString *)pathForArticle:(MWKArticle *)article
{
    return [self pathForTitle:article.title];
}

-(NSString *)pathForSectionsWithTitle:(MWKTitle *)title
{
    NSString *articlePath = [self pathForTitle:title];
    return [articlePath stringByAppendingPathComponent:@"sections"];
}

-(NSString *)pathForSectionId:(int)sectionId title:(MWKTitle *)title
{
    NSString *sectionsPath = [self pathForSectionsWithTitle:title];
    NSString *sectionName = [NSString stringWithFormat:@"section%d", sectionId];
    return [sectionsPath stringByAppendingPathComponent:sectionName];
}

-(NSString *)pathForSection:(MWKSection *)section
{
    return [self pathForSectionId:section.sectionId title:section.title];
}

-(NSString *)pathForImagesWithTitle:(MWKTitle *)title
{
    NSString *articlePath = [self pathForTitle:title];
    return [articlePath stringByAppendingPathComponent:@"Images"];
}

-(NSString *)pathForImageURL:(NSString *)url title:(MWKTitle *)title
{
    NSString *imagesPath = [self pathForImagesWithTitle:title];
    NSString *encURL = [self safeFilenameWithImageURL:url];
    return [imagesPath stringByAppendingPathComponent:encURL];
}

-(NSString *)pathForImage:(MWKImage *)image
{
    return [self pathForImageURL:image.sourceURL title:image.title];
}

-(NSString *)safeFilenameWithString:(NSString *)str
{
    // This handy function does most of the percent-escaping
    NSString *encodedStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    // But it leaves "/" and "&" intact. Naughty!
    encodedStr = [encodedStr stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    encodedStr = [encodedStr stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];

    return encodedStr;
}

-(NSString *)safeFilenameWithImageURL:(NSString *)str
{
    NSString *prefix = @"https://upload.wikimedia.org/";
    if ([str hasPrefix:prefix]) {
        NSString *suffix = [str substringFromIndex:[prefix length]];

        // Image URLs are already percent-encoded, so don't double-encode em.

        // "/" occurs in those nasty paths! but ":" cannot so let's use it
        // just like Mac OS X does ;)
        NSString *noslashes = [suffix stringByReplacingOccurrencesOfString:@"/" withString:@":"];
        return noslashes;
    } else {
        @throw [NSException exceptionWithName:@"MWKDataStoreException"
                                       reason:@"Tried to save non-upload.wikimedia.org URL as image"
                                     userInfo:@{@"str": str}];
    }
}

#pragma mark - save methods

-(void)ensurePathExists:(NSString *)path
{
    NSError *err;
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&err];
    if (err) {
        @throw [NSException exceptionWithName:@"MWKDataStoreException"
                                       reason:@"path creation failure"
                                     userInfo:@{@"path": path, @"error": err}];
    }
}

-(void)saveDictionary:(NSDictionary *)dict path:(NSString *)path name:(NSString *)name
{
    [self ensurePathExists:path];
    
    NSString *filePath = [path stringByAppendingPathComponent:name];
    if (![dict writeToFile:filePath atomically:YES]) {
        @throw [NSException exceptionWithName:@"MWKDataStoreException"
                                       reason:@"dictionary file atomic write failure"
                                     userInfo:@{@"filePath": filePath}];
    }
}

-(void)saveString:(NSString *)string path:(NSString *)path name:(NSString *)name
{
    [self ensurePathExists:path];
    
    NSError *err;
    NSString *filePath = [path stringByAppendingPathComponent:name];
    if (![string writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        if (err) {
            @throw [NSException exceptionWithName:@"MWKDataStoreException"
                                           reason:[err description]
                                         userInfo:@{@"filePath": filePath, @"err": err}];
        } else {
            @throw [NSException exceptionWithName:@"MWKDataStoreException"
                                           reason:@"string file atomic write failure"
                                         userInfo:@{@"filePath": filePath}];
        }
    }
}

-(void)saveData:(NSData *)data path:(NSString *)path name:(NSString *)name
{
    [self ensurePathExists:path];
    
    NSError *err;
    NSString *filePath = [path stringByAppendingPathComponent:name];
    if (![data writeToFile:filePath options:NSDataWritingAtomic error:&err]) {
        if (err) {
            @throw [NSException exceptionWithName:@"MWKDataStoreException"
                                           reason:[err description]
                                         userInfo:@{@"filePath": filePath, @"err": err}];
        } else {
            @throw [NSException exceptionWithName:@"MWKDataStoreException"
                                           reason:@"data file atomic write failure"
                                         userInfo:@{@"filePath": filePath}];
        }
    }
}

-(void)saveArticle:(MWKArticle *)article
{
    NSString *path = [self pathForArticle:article];
    NSDictionary *export = [article dataExport];
    [self saveDictionary:export path:path name:@"Article.plist"];
}

-(void)saveSection:(MWKSection *)section
{
    NSString *path = [self pathForSection:section];
    NSDictionary *export = [section dataExport];
    [self saveDictionary:export path:path name:@"Section.plist"];
}

-(void)saveSectionText:(NSString *)html section:(MWKSection *)section
{
    NSString *path = [self pathForSection:section];
    [self saveString:html path:path name:@"Section.html"];
}

-(void)saveImage:(MWKImage *)image
{
    NSString *path = [self pathForImage:image];
    NSDictionary *export = [image dataExport];
    [self saveDictionary:export path:path name:@"Image.plist"];
}

-(void)saveImageData:(NSData *)data image:(MWKImage *)image mimeType:(NSString *)mimeType
{
    NSString *path = [self pathForImage:image];
    NSString *filename = [@"Image" stringByAppendingPathExtension:image.extension];
    [self saveData:data path:path name:filename];
    
    [image updateWithData:data mimeType:mimeType];
    [self saveImage:image];
}

-(void)saveHistoryList:(MWKHistoryList *)list
{
    NSString *path = self.basePath;
    NSDictionary *export = [list dataExport];
    [self saveDictionary:export path:path name:@"History.plist"];
}

-(void)saveSavedPageList:(MWKSavedPageList *)list
{
    NSString *path = self.basePath;
    NSDictionary *export = [list dataExport];
    [self saveDictionary:export path:path name:@"SavedPages.plist"];
}

#pragma mark - load methods

-(MWKArticle *)articleWithTitle:(MWKTitle *)title
{
    NSString *path = [self pathForTitle:title];
    NSString *filePath = [path stringByAppendingPathComponent:@"Article.plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return [[MWKArticle alloc] initWithTitle:title dict:dict];
}

-(MWKSection *)sectionWithId:(int)sectionId article:(MWKArticle *)article
{
    NSString *path = [self pathForSectionId:sectionId title:article.title];
    NSString *filePath = [path stringByAppendingPathComponent:@"Section.plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return [[MWKSection alloc] initWithArticle:article dict:dict];
}

-(NSString *)sectionTextWithId:(int)sectionId article:(MWKArticle *)article
{
    NSString *path = [self pathForSectionId:sectionId title:article.title];
    NSString *filePath = [path stringByAppendingPathComponent:@"Section.plist"];
    
    NSError *err;
    NSString *html = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    if (err) {
        @throw [NSException exceptionWithName:@"MWKDataStoreException"
                                       reason:err.description
                                     userInfo:@{@"filePath": filePath, @"err": err}];
    }

    return html;
}

-(MWKImage *)imageWithURL:(NSString *)url title:(MWKTitle *)title
{
    NSString *path = [self pathForImageURL:url title:title];
    NSString *filePath = [path stringByAppendingPathComponent:@"Image.plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if (dict) {
        return [[MWKImage alloc] initWithTitle:title dict:dict];
    } else {
        return nil;
    }
}

-(NSData *)imageDataWithImage:(MWKImage *)image
{
    NSString *path = [self pathForImage:image];
    NSString *fileName = [@"Image" stringByAppendingPathExtension:image.extension];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];

    NSError *err;
    NSData *data = [NSData dataWithContentsOfFile:filePath options:0 error:&err];
    if (err) {
        @throw [NSException exceptionWithName:@"MWKDataStoreException"
                                       reason:[err description]
                                     userInfo:@{@"filePath": filePath, @"err": err}];
    }
    return data;
}

-(MWKHistoryList *)historyList
{
    NSString *path = self.basePath;
    NSString *filePath = [path stringByAppendingPathComponent:@"History.plist"];
    
    NSDictionary *dict =[NSDictionary dictionaryWithContentsOfFile:filePath];
    if (dict) {
        return [[MWKHistoryList alloc] initWithDict:dict];
    } else {
        return nil;
    }
}

-(MWKSavedPageList *)savedPageList
{
    NSString *path = self.basePath;
    NSString *filePath = [path stringByAppendingPathComponent:@"SavedPages.plist"];
    
    NSDictionary *dict =[NSDictionary dictionaryWithContentsOfFile:filePath];
    if (dict) {
        return [[MWKSavedPageList alloc] initWithDict:dict];
    } else {
        return nil;
    }
}


#pragma mark - helper methods

-(MWKArticleStore *)articleStoreWithTitle:(MWKTitle *)title
{
    return [[MWKArticleStore alloc] initWithTitle:title dataStore:self];
}

@end
