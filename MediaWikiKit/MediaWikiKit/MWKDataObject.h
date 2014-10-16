//
//  MWKDataObject.h
//  MediaWikiKit
//
//  Created by Brion on 10/14/14.
//  Copyright (c) 2014 Wikimedia Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MWKTitle;
@class MWKSite;
@class MWKUser;

@interface MWKDataObject : NSObject

@property (readonly) MWKSite *site;

- (instancetype)initWithSite:(MWKSite *)site;
- (id)dataExport;

- (NSString *)optionalString:(NSString *)key dict:(NSDictionary *)dict;
- (NSString *)requiredString:(NSString *)key dict:(NSDictionary *)dict;

- (NSNumber *)optionalNumber:(NSString *)key dict:(NSDictionary *)dict;
- (NSNumber *)requiredNumber:(NSString *)key dict:(NSDictionary *)dict;
- (NSNumber *)numberWithString:(NSString *)str;

- (MWKTitle *)optionalTitle:(NSString *)key dict:(NSDictionary *)dict;
- (MWKTitle *)requiredTitle:(NSString *)key dict:(NSDictionary *)dict;

- (NSDate *)optionalDate:(NSString *)key dict:(NSDictionary *)dict;
- (NSDate *)requiredDate:(NSString *)key dict:(NSDictionary *)dict;
- (NSDate *)getDateFromIso8601DateString:(NSString *)string;
- (NSString *)iso8601DateString:(NSDate *)date;

- (MWKUser *)optionalUser:(NSString *)key dict:(NSDictionary *)dict;
- (MWKUser *)requiredUser:(NSString *)key dict:(NSDictionary *)dict;

- (NSDictionary *)optionalDictionary:(NSString *)key dict:(NSDictionary *)dict;
- (NSDictionary *)requiredDictionary:(NSString *)key dict:(NSDictionary *)dict;

@end
