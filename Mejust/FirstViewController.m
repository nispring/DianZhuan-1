//
//  FirstViewController.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-24.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "FirstViewController.h"
#import "AFHelper.h"
#import "SSWebViewController.h"
#import "LoginViewController.h"
#import "SearchViewController.h"
#import "BundleHelper.h"

@interface FirstViewController ()<UIScrollViewDelegate>{
    
    UITableView *_table;
    UIPageControl *_pageControl;
    
    BOOL _searchViewFlag;
    BOOL _settingViewFlag;

}

#define TOPBUTTON 100
#define TOPSCROLL 1000
#define CONTENTSCROLL 1001
#define LINEIMAGE 999
#define SHADOWVIEW 998
#define SEARCHBUTTON 996
#define SETTINTBUTTON 997

@end

@implementation FirstViewController

- (void)loadView{
    [super loadView];
    if(IOS_7){
        self.edgesForExtendedLayout = 0;
    }
    
    if ([[USER_DEFAULT objectForKey:@"firstLaunch"]intValue]==1) {
        self.navigationController.navigationBarHidden = NO;
    }else{
        self.navigationController.navigationBarHidden = YES;
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithFileName:@"navigation bar"] forBarMetrics:UIBarMetricsDefault];
    CGRect rect = CGRectMake(0, 0, 100, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"米珈社区";
    label.textAlignment = 1;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = label;
    
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(230.0f, 12.5f, 22.0f, 22.0f)];
    [searchBtn addTarget:self action:@selector(doSearch:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.tag = SEARCHBUTTON;
    [searchBtn setBackgroundImage:[UIImage imageWithFileName:@"uinavigation_search"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:searchBtn];
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setFrame:CGRectMake(280.0f, 12.5f, 22.0f, 22.0f)];
    [settingBtn addTarget:self action:@selector(doSetting:) forControlEvents:UIControlEventTouchUpInside];
    settingBtn.tag = SETTINTBUTTON;
    [settingBtn setBackgroundImage:[UIImage imageWithFileName:@"uinavigation_setting"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:settingBtn];
    
    UIScrollView *topScroll = [[UIScrollView alloc]init];
    topScroll.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 35);
    [self.view addSubview:topScroll];
    topScroll.tag = TOPSCROLL;
    topScroll.delegate = self;
    topScroll.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topscrollview_top_bg"]];
    for(int i=0;i<2;i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [topScroll addSubview:button];
        button.frame = CGRectMake(45+i*150, 7.5, 90, 20);
        [button setTitle:i==0?@"广场":@"个人空间" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = TOPBUTTON+i;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [button addTarget:self action:@selector(doTopChick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageview = [[UIImageView alloc]init];
        [topScroll addSubview:imageview];
        imageview.tag = LINEIMAGE;
        imageview.image = [UIImage imageNamed:@"main_bottom_line"];
        
        if(i==0){
            [button setTitleColor:[UIColor colorWithStr:@"fd611c"] forState:UIControlStateNormal];
            imageview.frame = CGRectMake(button.left, button.bottom+5, button.width, 5);
        }
    }
    
    UIScrollView *contentScroll = [[UIScrollView alloc]init];
    contentScroll.frame = CGRectMake(0, 35, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT-64-35);
    contentScroll.contentSize = CGSizeMake(APP_SCREEN_WIDTH*2, APP_SCREEN_HEIGHT-64-35);
    contentScroll.pagingEnabled = YES;
    contentScroll.bounces = NO;
    contentScroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:contentScroll];
    contentScroll.delegate =self;
    contentScroll.tag = CONTENTSCROLL;
    
    for(int i=0;i<2;i++){
        UIScrollView *scroll = [[UIScrollView alloc]init];
        scroll.frame = CGRectMake(APP_SCREEN_WIDTH*i,0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT-64-35);
        [contentScroll addSubview:scroll];
        NSArray *titles;
        NSArray *subTitles;
        NSArray *icons;
        int count;
        if(i==0){
            titles=@[@"米珈云城市",@"米珈云商城",@"最新促销",@"米珈云社区",@"我要开云店"];
            subTitles=@[@"",@"",@"发现您身边的精彩",@"真正的本地实惠商城",@"即时了解最新促销信息",@"某个地理位置的店铺集合",@"一分钟完成您的互联梦"];
            icons =@[@"weiji",@"mijiasc",@"cuxiao",@"shequ",@"dianlaoban"];
            count=5;
        }
        if(i==1){
            titles=@[@"我的收藏",@"我的订单",@"会员中心"];
            icons =@[@"goodsshoucang",@"myorder",@"huiyuancenter"];
            count=3;
        }
        i==0?(count=5):(count=3);
        for(int j=0;j<count;j++){
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 5+j*55, APP_SCREEN_WIDTH, 55);
            [scroll addSubview:button];
            button.tag = 100000+j;
            [button setBackgroundImage:[UIImage imageNamed:@"button_press"] forState:UIControlStateHighlighted];
            if(i==0){
                [button addTarget:self action:@selector(doScroll1Button:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [button addTarget:self action:@selector(doScroll2Button:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            UILabel *label = [[UILabel alloc]init];
            [button addSubview:label];
            label.frame = CGRectMake(90, 17.5, 100, 20);
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont boldSystemFontOfSize:15];
            label.text = titles[j];
            
            if(i==0&&j>1){
                label.frame = CGRectMake(90, 10, 100, 20);
            }
            UILabel *subLabel = [[UILabel alloc]init];
            [button addSubview:subLabel];
            subLabel.frame = CGRectMake(90, 30, 200, 20);
            subLabel.backgroundColor = [UIColor clearColor];
            subLabel.textColor = [UIColor grayColor];
            subLabel.font = [UIFont systemFontOfSize:13];
            subLabel.text = subTitles[j];
            
            //icon line arror
            for(int m=0;m<3;m++){
                UIImageView *imageview = [[UIImageView alloc]init];
                [button addSubview:imageview];
                switch (m) {
                    case 0:
                        imageview.frame = CGRectMake(45, 12.5, 30, 30);
                        imageview.image = [UIImage imageNamed:icons[j]];
                        break;
                    case 1:
                        imageview.frame = CGRectMake(0, 54, APP_SCREEN_WIDTH, 1);
                        imageview.backgroundColor = [UIColor colorWithStr:@"b8b8b8"];
                        break;
                    case 2:
                        imageview.frame = CGRectMake(280, 18, 10, 20);
                        imageview.image = [UIImage imageNamed:@"left_arror"];
                        break;
                }
            }
            
        }
        scroll.contentSize = CGSizeMake(APP_SCREEN_WIDTH, titles.count*56);
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getMiJiaData];
}
- (void)doScroll1Button:(UIButton *)sender{
    [UIView animateWithDuration:0.2f animations:^{
        sender.backgroundColor = [UIColor colorWithStr:@"0963c8"];
    } completion:^(BOOL finish){
        sender.backgroundColor = [UIColor whiteColor];
    }];
    NSDictionary *dic;
    dic = [USER_DEFAULT objectForKey:MiJia_INFO];
    SSWebViewController *vc = [[SSWebViewController alloc]init];
    NSArray *arrays = @[[dic objectForKey:@"url_wei_shop"],[dic objectForKey:@"url_mejust_shop"],[dic objectForKey:@"url_newest_goods"],[dic objectForKey:@"url_community"],[dic objectForKey:@"url_supplier_download_ios"]];
    switch (sender.tag) {
        case 100000: //微街
        case 100001: //米珈商城
        case 100002: //最新促销
        case 100003: //米珈云社区
            [vc loadURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",arrays[sender.tag-100000]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]]];
            break;
        case 100004: { //我要开云店
            NSURL *mejustbusiness = [NSURL URLWithString:@"mejustbusiness://location?id=1"];
            if([[UIApplication sharedApplication] canOpenURL:mejustbusiness]){
                [[UIApplication sharedApplication] openURL:mejustbusiness];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:arrays[sender.tag-100000]]];
            }
            return;
        }
            break;
    }
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)doScroll2Button:(UIButton *)sender{
    [UIView animateWithDuration:0.2f animations:^{
        sender.backgroundColor = [UIColor colorWithStr:@"0963c8"];
    } completion:^(BOOL finish){
        sender.backgroundColor = [UIColor whiteColor];
    }];
    
    if([[USER_DEFAULT objectForKey:IS_LOGIN]intValue]==1){
        DLog(@"123123123123");
        NSDictionary *userDic = [USER_DEFAULT objectForKey:USER_INFO];
        NSArray *arrays = @[userDic[@"url_goods_collect"],userDic[@"url_self_order_list"],userDic[@"url_user_center"]];
        NSString *url = [arrays objectAtIndex:sender.tag-100000];
        SSWebViewController *vc = [[SSWebViewController alloc]init];
        [vc loadURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",url]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        LoginViewController *vc = [[LoginViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)doTopChick:(UIButton *)sender{
    for(int i=0;i<2;i++){
        UIButton *button = (UIButton *)[self.view viewWithTag:TOPBUTTON+i];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [sender setTitleColor:[UIColor colorWithStr:@"fd611c"] forState:UIControlStateNormal];
    
    UIImageView *imageview = (UIImageView *)[self.view viewWithTag:LINEIMAGE];
    [UIView animateWithDuration:0.1 animations:^{
        imageview.frame = CGRectMake(sender.left, sender.bottom+5, sender.width, 4);
    }];
    
    UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:CONTENTSCROLL];
    [scroll scrollRectToVisible:CGRectMake((sender.tag-100)*APP_SCREEN_WIDTH, scroll.top, scroll.width, scroll.height) animated:YES];
    DLog(@"%d",sender.tag);
}


- (void)doSearch:(UIButton *)sender{
    UIView *view = (UIView *)[self.view viewWithTag:SHADOWVIEW];
    if(view){
        [self removeShadowView];
        _searchViewFlag = NO;
        if(_settingViewFlag){
            [self createShadowView:sender];
            _settingViewFlag = NO;
            _searchViewFlag = YES;
        }
    }
    else{
        [self createShadowView:sender];
        _searchViewFlag = YES;
    }
}
- (void)doSetting:(UIButton *)sender{
    UIView *view = (UIView *)[self.view viewWithTag:SHADOWVIEW];
    if(view){
        [self removeShadowView];
        _settingViewFlag = NO;
        if(_searchViewFlag){
            [self createShadowView:sender];
            _searchViewFlag = NO;
            _settingViewFlag = YES;
        }
    }
    else{
        [self createShadowView:sender];
        _settingViewFlag = YES;
    }
}
- (void)createShadowView:(UIButton *)sender{
    
    NSArray *icons = @[@"search_goods",@"searcg_shop",@"search_center"];
    NSArray *titles = @[@"搜索商品",@"搜索商铺",@"搜索社区"];
    
    if(sender.tag == SEARCHBUTTON){  //搜索
        icons = @[@"search_goods",@"searcg_shop",@"search_center"];
        titles = @[@"搜索商品",@"搜索商铺",@"搜索社区"];
    }else{
        icons = @[@"about",@"version",@"return"];
        titles = @[@"关于米珈",@"版本更新",([[USER_DEFAULT objectForKey:IS_LOGIN] intValue]==1)?@"注销":@"登陆"];
    }
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, -100, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
    view.tag = SHADOWVIEW;
    [self.view addSubview:view];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doShdadowChick:)];
    [view addGestureRecognizer:gesture];
    
    UIView *shadowView = [[UIView alloc]init];
    [view addSubview:shadowView];
    shadowView.frame = CGRectMake((sender.tag==SEARCHBUTTON?(sender.left-30):sender.left-50), 0, 90, 40*icons.count);
    shadowView.backgroundColor = [UIColor blackColor];
    
    for(int i=0;i<icons.count;i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [shadowView addSubview:button];
        button.frame = CGRectMake(0, i*40, 90, 40);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:11.5];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, ((i==3)&&sender.tag != SEARCHBUTTON)?-10:15, 0, 0)];
        button.tag = 10000+i;
        
        UIImageView *iconImageview = [[UIImageView alloc]init];
        [button addSubview:iconImageview];
        iconImageview.frame = CGRectMake(10, 14, 11.5, 11.5);
        iconImageview.image = [UIImage imageNamed:icons[i]];
        
        if(sender.tag==SEARCHBUTTON){
            [button addTarget:self action:@selector(doSearchType:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            [button addTarget:self action:@selector(doSettingType:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIImageView *imageview = [[UIImageView alloc]init];
        [shadowView addSubview:imageview];
        imageview.frame = CGRectMake(0, button.bottom, button.width, 1);
        if(i!=3){
            imageview.backgroundColor = [UIColor colorWithStr:@"676767"];
        }
    }
    [UIView animateWithDuration:0.3f animations:^{
        view.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
    }];
}
- (void)doSearchType:(UIButton *)sender{
    
    [self removeShadowView];
    SearchViewController *vc = [[SearchViewController alloc]init];
    if(sender.tag==10000){
        vc.title = @"搜索商品";
        vc.baseUrlStr =[USER_DEFAULT objectForKey:MiJia_INFO][@"url_search_goods_list"];
    }
    if(sender.tag==10001){
        vc.title = @"搜索商铺";
        vc.baseUrlStr = [USER_DEFAULT objectForKey:MiJia_INFO][@"url_search_shop_list"];
    }
    if(sender.tag==10002){
        vc.title = @"搜索社区";
        vc.baseUrlStr = [USER_DEFAULT objectForKey:MiJia_INFO][@"url_search_community_list"];
    }
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)doSettingType:(UIButton *)sender{
    [self removeShadowView];
    if(sender.tag==10000){ //关于
        NSString *oldVersion = [BundleHelper bundleShortVersionString];
        [UIAlertView showAlertViewWithMessage:[NSString stringWithFormat:@"米珈(%@)",oldVersion]];
    }
    if(sender.tag==10001){ //版本更新
        [UIAlertView showAlertViewWithMessage:@"最新版本"];
    }
    if(sender.tag==10002){ //注销或者登陆
        if([[USER_DEFAULT objectForKey:IS_LOGIN]intValue]==1){
            //清除登陆状态
            [USER_DEFAULT setObject:@"0" forKey:IS_LOGIN];
            //清除用户数据
            [USER_DEFAULT removeObjectForKey:USER_INFO];
            [USER_DEFAULT synchronize];
            //清除keychain数据密码
            [CBKeyChain delete:KEY_USERNAME_PASSWORD];
            UIButton *button = (UIButton *)[self.view viewWithTag:10003];
            [button setTitle:@"登陆" forState:UIControlStateNormal];

        }else{
            LoginViewController *vc = [[LoginViewController alloc]init];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

- (void)removeShadowView{
    UIView *view = (UIView *)[self.view viewWithTag:SHADOWVIEW];
    [UIView animateWithDuration:0.1f animations:^{
        view.frame = CGRectMake(0, -120, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
    } completion:^(BOOL complete){
        [view removeFromSuperview];
        _searchViewFlag = NO;
        _settingViewFlag = NO;
    }];
}
- (void)doShdadowChick:(UITapGestureRecognizer *)gesture{
    [self removeShadowView];
}
#pragma scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    // 设置页码
    _pageControl.currentPage = page;
}

- (void)getMiJiaData{
    NSDictionary *dic = @{@"act":@"mejust_config"};
    [AFHelper downDataWithViewController:self Dictionary:dic andBaseURLStr:Web_Servr_URL andPostPath:MicroShopUser success:^(NSDictionary *dic){
        if([[dic objectForKey:@"flag"]intValue]==1){
            [USER_DEFAULT setObject:dic forKey:MiJia_INFO];
            [USER_DEFAULT synchronize];
        }
        else{
            [UIAlertView showAlertViewWithMessage:[dic objectForKey:@"message"]];
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
