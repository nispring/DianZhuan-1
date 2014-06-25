//
//  AFHelper.m
//  Mejust_Business
//
//  Created by 时代合盛 on 14-3-4.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "AFHelper.h"
#import "AFNetworking.h"
@implementation AFHelper

+(void)downDataWithViewController:(UIViewController *)viewController Dictionary:(NSDictionary *)dic andBaseURLStr:(NSString *)baseUrlStr andPostPath:(NSString *)postPath success:(CBSuccessBlock)success {
    DLog(@"%@",dic);
    if(viewController){
        DLog(@"has no vc");
    }
    NSURL *baseUrl = [NSURL URLWithString:baseUrlStr];
    AFHTTPClient *aClient = [AFHTTPClient clientWithBaseURL:baseUrl];
    [aClient postPath:postPath parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(viewController){
        }
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:1 error:nil];
        if([[dic objectForKey:@"errorno"]intValue]==110){
            //清除登陆状态
            [USER_DEFAULT setObject:@"0" forKey:IS_LOGIN];
            
            //清除用户数据
            [USER_DEFAULT removeObjectForKey:USER_INFO];
            [USER_DEFAULT synchronize];
            
            [UIAlertView showAlertViewWithMessage:[dic objectForKey:@"message"]];
            return ;
        }
        success(dic);
        DLog(@"%@",dic);

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(viewController){
        }
        [UIAlertView showAlertViewWithMessage:@"网络连接失败"];
    }];
}
@end
