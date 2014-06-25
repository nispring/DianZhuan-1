//
//  LoginViewController.m
//  MiJia
//
//  Created by 时代合盛 on 14-3-13.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "LoginViewController.h"
#import "FirstViewController.h"
#import "CBAppDelegate.h"
#import "CBKeyChain.h"
#import "AFHelper.h"
@interface LoginViewController ()<UITextFieldDelegate,UIScrollViewDelegate>{
    UIPageControl *_pageControl;
}

@end

@implementation LoginViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshName" object:nil];

}
- (void)loadView{
    [super loadView];
    if(IOS_7){
        self.edgesForExtendedLayout = 0;
    }

    [NOTIFICATION_CENTER addObserver:self selector:@selector(refreshName) name:@"refreshName" object:nil];
    [self createView];
}
- (void)refreshName{
    UITextField *name = (UITextField *)[self.view viewWithTag:100];
    name.text = [USER_DEFAULT objectForKey:USERNAME];
}
- (void)createView{
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageWithFileName:@"login_bg"]];
    [self.view addSubview:bgImageView];
    bgImageView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
    
    UIButton *backButton = [[UIButton alloc]init];
    [self.view addSubview:backButton];
    [backButton setBackgroundImage:[UIImage imageWithFileName:@"navigation_back"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(20, 30, 30, 30);
    backButton.tag = 1005;
    [backButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];

    //用户登陆文字
    UILabel *showLabel = [[UILabel alloc]init];
    [self.view addSubview:showLabel];
    showLabel.textAlignment = 1;
    showLabel.frame = CGRectMake(0,IS_4_INCH?170:120, 320, 20);
    showLabel.backgroundColor = [UIColor clearColor];
    showLabel.text = @"用户登陆";
    showLabel.font = [UIFont boldSystemFontOfSize:20];
    showLabel.textColor = [UIColor whiteColor];

    //输入框
    for(int i=0;i<2;i++){
        //icon
        UIImageView *iconImage = [[UIImageView alloc]init];
        [self.view addSubview:iconImage];
        iconImage.frame = CGRectMake(40, showLabel.bottom+30+i*50, 20, 20);

        UITextField *textField = [[UITextField alloc]init];
        [self.view addSubview:textField];
        textField.delegate = self;
        textField.frame = CGRectMake(iconImage.left+30, iconImage.top, 210, 20);
        textField.font = [UIFont systemFontOfSize:18];
        textField.textColor = [UIColor whiteColor];
        textField.tag = 100+i;
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;

        //绘制下划线
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(30, iconImage.bottom+5, 260,1);
        [self.view.layer addSublayer:bottomBorder];
        bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:button];
        button.tag = 1000+i;
        button.frame = CGRectMake(30, showLabel.bottom+160+i*55, 260, 40);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [button addTarget:self action:@selector(doChick:) forControlEvents:UIControlEventTouchUpInside];

        if(i==0){
            textField.returnKeyType = UIReturnKeyNext;
            if([USER_DEFAULT objectForKey:USERNAME]){
                textField.text = [USER_DEFAULT objectForKey:USERNAME];
            }else{
                textField.placeholder = @"用户名";
            }
            iconImage.image = [UIImage imageWithFileName:@"person"];
            [button setBackgroundImage:[UIImage imageWithFileName:@"landing"] forState:UIControlStateNormal];
            [button setTitle:@"登陆" forState:UIControlStateNormal];
        }
        if(i==1){
            textField.returnKeyType = UIReturnKeyDone;
            textField.placeholder = @"密码";
            textField.secureTextEntry = YES;
            iconImage.image = [UIImage imageWithFileName:@"password"];
        }
    }
    
}

- (void)doBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doChick:(UIButton *)sender{
    switch (sender.tag) {
        case 1000:
            [self goLogin];
            break;
        case 1001:
            [self goRegister];
            break;
        case 1002:
            [self goForget];
            break;
    }
}

- (void)goLogin{
    [self.view endEditing:YES];
    UITextField *user = (UITextField *)[self.view viewWithTag:100];
    UITextField *pwd = (UITextField *)[self.view viewWithTag:101];

    if(user.text.length<1||pwd.text.length<1){
        [UIAlertView showAlertViewWithMessage:@"请完整输入"];
    }
    else{
        NSDictionary *dic = @{@"act":@"login",@"username":user.text,@"password":[pwd.text MD5Hash]};
        [AFHelper downDataWithViewController:self Dictionary:dic andBaseURLStr:Web_Servr_URL andPostPath:MicroShopUser success:^(NSDictionary *dic){
            if([[dic objectForKey:@"flag"]intValue]==1){
                //保存用户名和密码kechain
                NSDictionary *usernamepasswordKVPairs = @{KEY_USERNAME:user.text,KEY_PASSWORD:[pwd.text MD5Hash]};
                [CBKeyChain save:KEY_USERNAME_PASSWORD data:usernamepasswordKVPairs];
                
                [USER_DEFAULT setObject:user.text forKey:USERNAME];
                [USER_DEFAULT setObject:@"1" forKey:IS_LOGIN];
                [USER_DEFAULT setObject:[dic objectForKey:@"userinfo"] forKey:USER_INFO];
                [USER_DEFAULT synchronize];

                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else{
                [UIAlertView showAlertViewWithMessage:[dic objectForKey:@"message"]];
            }
        }];
    }
}

- (void)goRegister{
}
- (void)goForget{
}

#pragma mark uitextfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    UITextField *text = (UITextField *)[self.view viewWithTag:101];
    if(textField.tag == 100){
        [text becomeFirstResponder];
    }else{
        [self goLogin];
    }
    return YES;
}

- (void)clearnFirstLauch{
    UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:99999];
    [UIView animateWithDuration:1 animations:^{
        scroll.alpha = 0;
        [_pageControl removeFromSuperview];
    } completion:^(BOOL complete){
        [scroll removeFromSuperview];
        [USER_DEFAULT setObject:@"1" forKey:@"firstLaunch"];
        [USER_DEFAULT synchronize];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
