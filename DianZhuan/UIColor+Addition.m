//
//  UIColor+Addition.m
//  Mejust_Business
//
//  Created by 时代合盛 on 14-1-9.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "UIColor+Addition.h"

@implementation UIColor (Addition)

//(目前还有bug：黑白色计算出现错误)
+ (UIColor *)colorWithStr:(NSString *)hexStr
{
    long colorLong = strtoul([hexStr cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    // 通过位与方法获取三色值
    int R = (colorLong & 0xFF0000 )>>16;
    int G = (colorLong & 0x00FF00 )>>8;
    int B = colorLong & 0x0000FF;
    UIColor *GetColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];
    return GetColor;
    
}

@end
