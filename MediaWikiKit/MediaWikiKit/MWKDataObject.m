//
//  MWKDataObject.m
//  MediaWikiKit
//
//  Created by Brion on 10/14/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import "MediaWikiKit.h"

@implementation MWKDataObject

- (instancetype)initWithSite:(MWKSite *)site
{
    self = [self init];
    if (self) {
        _site = site;
    }
    return self;
}

#pragma mark - string methods

- (NSString *)optionalString:(NSString *)key dict:(NSDictionary *)dict
{
    id obj = dict[key];
    if (obj == nil) {
        return nil;
    } else if ([obj isKindOfClass:[NSString class]]) {
        return (NSString *)obj;
    } else {
        @throw [NSException exceptionWithName:@"MWKDataObjectException"
                                       reason:@"expected string, got something else"
                                     userInfo:@{@"key": key}];
    }
}

- (NSString *)requiredString:(NSString *)key dict:(NSDictionary *)dict
{
    NSString *str = [self optionalString:key dict:dict];
    if (str == nil) {
        @throw [NSException exceptionWithName:@"MWKDataObjectException"
                                       reason:@"expected string, got nothing"
                                     userInfo:@{@"key": key}];
    } else {
        return str;
    }
}

#pragma mark - number methods


- (NSNumber *)optionalNumber:(NSString *)key dict:(NSDictionary *)dict
{
    id obj = dict[key];
    if (obj == nil) {
        return nil;
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)obj;
    } else if ([obj isKindOfClass:[NSString class]]) {
        // PHP is often fuzzy and sometimes gives us strings when we wanted integers.
        return [self numberWithString:(NSString *)obj];
    } else {
        @throw [NSException exceptionWithName:@"MWKDataObjectException" reason:@"expected string or nothing, got something else" userInfo:nil];
    }
}

- (NSNumber *)requiredNumber:(NSString *)key dict:(NSDictionary *)dict
{
    NSNumber *num = [self optionalNumber:key dict:dict];
    if (num == nil) {
        @throw [NSException exceptionWithName:@"MWKDataObjectException"
                                       reason:@"missing required number field"
                                     userInfo:@{@"key": key}];
    } else {
        return num;
    }
}

- (NSNumber *)numberWithString:(NSString *)str
{
    if ([str containsString:@"."] || [str containsString:@"e"]) {
        double val = [str doubleValue];
        return [NSNumber numberWithDouble:val];
    } else {
        int val = [str intValue];
        return [NSNumber numberWithInt:val];
    }
}


#pragma mark - title methods

- (MWKTitle *)optionalTitle:(NSString *)key dict:(NSDictionary *)dict
{
    NSString *str = [self optionalString:key dict:dict];
    if (str == nil) {
        return nil;
    } else {
        return [self.site titleWithString:str];
    }
}

- (MWKTitle *)requiredTitle:(NSString *)key dict:(NSDictionary *)dict
{
    NSString *str = [self requiredString:key dict:dict];
    return [self.site titleWithString:str];
}


#pragma mark - date methods

- (NSDate *)optionalDate:(NSString *)key dict:(NSDictionary *)dict
{
    NSString *str = [self optionalString:key dict:dict];
    if (str == nil) {
        return nil;
    } else {
        return [self getDateFromIso8601DateString:str];
    }
}

- (NSDate *)requiredDate:(NSString *)key dict:(NSDictionary *)dict
{
    NSDate *date = [self optionalDate:key dict:dict];
    if (date == nil) {
        @throw [NSException exceptionWithName:@"MWKDataObjectException"
                                       reason:@"missing required date field"
                                     userInfo:@{@"key": key}];
    } else {
        return date;
    }
}


- (NSDate *)getDateFromIso8601DateString:(NSString *)string
{
    // See: https://www.mediawiki.org/wiki/Manual:WfTimestamp
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    return  [formatter dateFromString:string];
}

#pragma mark - user methods

- (MWKUser *)optionalUser:(NSString *)key dict:(NSDictionary *)dict
{
    NSDictionary *user = dict[key];
    if (user == nil) {
        return nil;
    } else if ([user isKindOfClass:[NSNull class]]) {
        return [self.site userWithAnonymous];
    } else if ([user isKindOfClass:[NSDictionary class]]) {
        return [self.site userWithName:dict[@"name"] gender:dict[@"gender"]];
    } else {
        @throw [NSException exceptionWithName:@"MWKDataObjectException"
                                       reason:@"expected user, got something else"
                                     userInfo:@{@"key": key}];
    }
}

- (MWKUser *)requiredUser:(NSString *)key dict:(NSDictionary *)dict
{
    MWKUser *user = [self optionalUser:key dict:dict];
    if (user == nil) {
        @throw [NSException exceptionWithName:@"MWKDataObjectException"
                                       reason:@"missing required user field"
                                     userInfo:@{@"key": key}];
    } else {
        return user;
    }
}

#pragma mark - dictionary methods

- (NSDictionary *)optionalDictionary:(NSString *)key dict:(NSDictionary *)dict
{
    id obj = dict[key];
    if ([obj isKindOfClass:[NSArray class]]) {
        // PHP likes to output empty associative arrays as empty JSON arrays,
        // which become empty NSArrays.
        return @{};
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)obj;
    } else {
        @throw [NSException exceptionWithName:@"MWKDataObjectException"
                                       reason:@"expected dictionary, got something else"
                                     userInfo:@{@"key": key}];
    }
}

- (NSDictionary *)requiredDictionary:(NSString *)key dict:(NSDictionary *)dict
{
    NSDictionary *obj = [self optionalDictionary:key dict:dict];
    if (obj == nil) {
        @throw [NSException exceptionWithName:@"MWKDataObjectException"
                                       reason:@"missing required dictionary field"
                                     userInfo:@{@"key": key}];
    } else {
        return obj;
    }
}


@end
