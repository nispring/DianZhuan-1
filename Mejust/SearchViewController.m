//
//  SearchViewController.m
//  MiJia
//
//  Created by 时代合盛 on 14-3-18.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "SearchViewController.h"
#import "SSWebViewController.h"
@interface SearchViewController ()<UITextFieldDelegate>{
    
    UITextField *_inputTF;
}

@end

@implementation SearchViewController
- (void)viewWillAppear:(BOOL)animated{
    [_inputTF becomeFirstResponder];
}
- (void)loadView{
    [super loadView];
    if(IOS_7){
        self.edgesForExtendedLayout = 0;
    }

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithFileName:@"navigation bar"] forBarMetrics:UIBarMetricsDefault];
    CGRect rect = CGRectMake(0, 0, 100, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor clearColor];
    label.text = self.title;
    label.textAlignment = 1;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = label;
    
    UIButton *backButton = [[UIButton alloc]init];
    [self.view addSubview:backButton];
    [backButton setBackgroundImage:[UIImage imageWithFileName:@"navigation_back"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(20, 30, 30, 30);
    [backButton addTarget:self action:@selector(doLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBar;

    [self createView];
}
- (void)createView{
    UIImageView *searchBG = [[UIImageView alloc]init];
    searchBG.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 50);
    [self.view addSubview:searchBG];
    searchBG.image = [UIImage imageWithFileName:@"topscrollview_top_bg"];
    searchBG.userInteractionEnabled = YES;
    
    UIImageView *inputBG = [[UIImageView alloc]init];
    [searchBG addSubview:inputBG];
    inputBG.frame = CGRectMake(20, 10, 220, 30);
    inputBG.image = [UIImage imageWithFileName:@"searchBG"];
    inputBG.userInteractionEnabled = YES;
    
    UIImageView *icon = [[UIImageView alloc]init];
    [inputBG addSubview:icon];
    icon.frame = CGRectMake(5, 5, 20, 20);
    icon.image = [UIImage imageWithFileName:@"search_icon"];
    
    _inputTF = [[UITextField alloc]init];
    [inputBG addSubview:_inputTF];
    _inputTF.delegate = self;
    _inputTF.frame = CGRectMake(icon.right+5, icon.top, 180, 20);
    _inputTF.returnKeyType = UIReturnKeySearch;
    
    UIButton *searchBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBG addSubview:searchBT];
    searchBT.frame = CGRectMake(inputBG.right+10, inputBG.top, 50, 30);
    [searchBT setBackgroundImage:[UIImage imageWithFileName:@"search_button"] forState:UIControlStateNormal];
    [searchBT setTitle:@"搜索" forState:UIControlStateNormal];
    searchBT.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [searchBT addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
}

- (void)doSearch{
    if(_inputTF.text.length<1){
        [UIAlertView showAlertViewWithMessage:@"请完整输入"];
        return;
    }
    SSWebViewController *vc = [[SSWebViewController alloc]init];
    [vc loadURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@&keywords=%@",self.baseUrlStr,_inputTF.text]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

    [self presentViewController:vc animated:YES completion:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self doSearch];
    return YES;
}
- (void)doLeft{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
