//
//  LaunchViewController.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-25.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "LaunchViewController.h"
#import "AFHelper.h"
#import "BundleHelper.h"
@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)loadView{
    [super loadView];
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.image = [UIImage imageNamed:@"Default"];
    imageview.frame = CGRectMake(0, IOS_7?0:-20, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
    [self.view addSubview:imageview];
    
    UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]init];
    act.center = imageview.center;
    act.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [act startAnimating];
    [imageview addSubview:act];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
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
