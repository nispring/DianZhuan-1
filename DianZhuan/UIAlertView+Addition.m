//
//  UIAlertView+Addition.m
//  Mejust_Business
//
//  Created by 时代合盛 on 14-1-8.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "UIAlertView+Addition.h"

@implementation UIAlertView (Addition)

+(void) showAlertViewWithMessage:(NSString *)message{
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:nil message:message  delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alert show];
    
}
+(void) showAlertViewWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:title message:message  delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alert show];
}

@end
