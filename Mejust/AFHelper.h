//
//  AFHelper.h
//  Mejust_Business
//
//  Created by 时代合盛 on 14-3-4.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockDef.h"

@interface AFHelper : NSObject


+(void)downDataWithViewController:(UIViewController *)viewController Dictionary:(NSDictionary *)dic andBaseURLStr:(NSString *)baseUrlStr andPostPath:(NSString *)postPath success:(CBSuccessBlock)success;
@end
