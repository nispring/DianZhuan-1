//
//  NSString+Addition.h
//  Mejust_Business
//
//  Created by 时代合盛 on 14-1-8.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)

- (NSString *)MD5Hash;

+(NSString*)fileMD5:(NSString*)path;

+(NSString*)dataMD5:(NSData*)data;

- (BOOL)isPhoneNumber;

- (BOOL)isEmail;

-(BOOL)containString:(NSString *)string;

- (NSDictionary *)parseURLParams;

//时间戳转时间
- (NSString *)convertToTimeString;

//字符串转nsdate
- (NSDate *)convertToDate;

//去除某个符号
-(NSString *)removeChar:(NSString *)string;

@end
