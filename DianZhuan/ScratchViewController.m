//
//  ScratchViewController.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-10.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "ScratchViewController.h"
#import "MDScratchImageView.h"

@interface ScratchViewController ()<MDScratchImageViewDelegate>

@end

@implementation ScratchViewController

- (void)loadView{
    [super loadView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, APP_SCREEN_WIDTH-100, 220)];
    imageView.image = [UIImage imageNamed:@"lottery_award@2x"];
    [self.view addSubview:imageView];
    
    UIImage *bluredImage = [UIImage imageNamed:@"paint01-01blur"];
    MDScratchImageView *scratchImageView = [[MDScratchImageView alloc] initWithFrame:imageView.frame];
    [scratchImageView setImage:bluredImage radius:50];
    scratchImageView.delegate = self;
    [self.view addSubview:scratchImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - MDScratchImageViewDelegate

- (void)mdScratchImageView:(MDScratchImageView *)scratchImageView didChangeMaskingProgress:(CGFloat)maskingProgress {
	NSLog(@"%s %p progress == %.2f", __PRETTY_FUNCTION__, scratchImageView, maskingProgress);
    if(maskingProgress>0.4){
        [UIAlertView showAlertViewWithMessage:@"恭喜你，中了个屁"];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
