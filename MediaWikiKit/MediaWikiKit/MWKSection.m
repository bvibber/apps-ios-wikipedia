//
//  MWKSection.m
//  MediaWikiKit
//
//  Created by Brion on 10/7/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MediaWikiKit.h"

@implementation MWKSection

-(instancetype)initWithArticle:(MWKArticle *)article dict:(NSDictionary *)dict
{
    self = [self initWithSite:article.site];
    if (self) {
        _article = article;
        _title = article.title;
        
        _toclevel   =  [self optionalNumber:@"toclevel"   dict:dict];
        _level      =  [self optionalNumber:@"toclevel"   dict:dict]; // may be a numeric string
        _line       =  [self optionalString:@"line"       dict:dict];
        _number     =  [self optionalString:@"number"     dict:dict]; // deceptively named, this must be a string
        _index      =  [self optionalString:@"index"      dict:dict]; // deceptively named, this must be a string
        _fromtitle  =  [self optionalTitle: @"fromtitle"  dict:dict];
        _sectionId  = [[self requiredNumber:@"id"         dict:dict] intValue];
        _references =  [self optionalString:@"references" dict:dict];
    }
    return self;
}

@end
