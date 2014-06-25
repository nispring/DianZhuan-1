//
//  FatherViewController.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-5.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "FatherViewController.h"

@interface FatherViewController ()

@end

@implementation FatherViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithStr:@"edf1f2"];
    if(IOS_7){
        self.edgesForExtendedLayout = 0;
    }

    UIButton *backButton = [[UIButton alloc]init];
    [self.view addSubview:backButton];
    
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.image = [UIImage imageNamed:@"navigation_back"];
    imageview.frame = CGRectMake(5, 0, 20, 23);
    [backButton addSubview:imageview];
    backButton.frame = CGRectMake(0, 0, 28, 25);
    [backButton addTarget:self action:@selector(doLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    //添加手势识别
    [self moveToRight];
}
- (void)doLeft{
    if([self.navigationController respondsToSelector:@selector(popToViewController:animated:)]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - uigesture
- (void)moveToRight{
    if([self.navigationController respondsToSelector:@selector(popToViewController:animated:)]){
        
        UISwipeGestureRecognizer *recognizer;
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self.view addGestureRecognizer:recognizer];
    }
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    //左滑
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
    }
    //右滑
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        if([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    //下滑
    if (recognizer.direction==UISwipeGestureRecognizerDirectionDown){
    }
    //上滑动
    if (recognizer.direction==UISwipeGestureRecognizerDirectionUp){
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
