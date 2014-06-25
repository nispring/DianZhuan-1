//
//  CBKeyChain.h
//  Mejust_Business
//
//  Created by 时代合盛 on 13-12-27.
//  Copyright (c) 2013年 时代合盛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
@interface CBKeyChain : NSObject
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
