//
//  TurntableViewController.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-11.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "TurntableViewController.h"

@interface TurntableViewController (){
    UIImageView *image1,*image2;
    UIButton *btn_start;
    
    float random;
    float orign;
    
}

@end

@implementation TurntableViewController

- (void)loadView{
    [super loadView];
    self.title = @"每日签到";
    if(IOS_7){
        self.edgesForExtendedLayout = 0;
    }
    UIImageView *bgImageview = [[UIImageView alloc]init];
    bgImageview.image = [UIImage imageNamed:@"trunBG"];
    bgImageview.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT-64);
    [self.view addSubview:bgImageview];
    
    
    //添加转盘
    UIImageView *image_disk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disk"]];
    image_disk.frame = CGRectMake(20.0, 60.0, 280.0, 280.0);
    image1 = image_disk;
    [self.view addSubview:image1];
    
    //添加转针
    UIImageView *image_start = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"start.png"]];
    image_start.frame = CGRectMake(112.0, 100.0, 100.0, 200.0);
    image2 = image_start;
    [self.view addSubview:image2];
    
    //添加按钮
    btn_start = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_start.frame = CGRectMake(130.0, 160.0, 70.0, 70.0);
    [btn_start addTarget:self action:@selector(choujiang) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_start];
    
    random = .0;
    orign = .0;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)choujiang
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDate *localDate = [[NSDate date]  dateByAddingTimeInterval: [zone secondsFromGMTForDate: [NSDate date]]];
    [USER_DEFAULT setObject:localDate forKey:RECORDDATE];

    
    btn_start.enabled = NO;
    //  概率测试
    //    NSInteger count01=0;
    //    NSInteger count02=0;
    //    NSInteger count03=0;
    //    NSInteger count04=0;
    //
    //    for (NSInteger i=0; i<100000; i++) {
    //        NSInteger rValue = (arc4random()%10000);
    //        if (rValue<=(10)) {
    //            //8 --->1
    //            orign=(1.0/12.0);
    //            count01 ++;
    //        }else if (rValue<=(100)){
    //            //3---->1
    //            orign = (21.0/12.0);
    //            count02++;
    //        }else if (rValue<=(590)){
    //            //0.5--->2
    //            orign = (17.0/12.0);
    //            count03++;
    //        }else {
    //            //0.1--->3
    //            orign = (13.0/12.0);
    //            count04++;
    //        }
    //    }
    //    NSLog(@"count01=%0.2f%%",(count01/100000.0)*100);
    //    NSLog(@"count02=%0.2f%%",(count02/100000.0)*100);
    //    NSLog(@"count03=%0.2f%%",(count03/100000.0)*100);
    //    NSLog(@"count04=%0.2f%%",(count04/100000.0)*100);
    //ps:需要在触发方法前初始化random = .0、orign = .0
    //抽奖概率控制
    NSInteger rValue = (arc4random()%10000);
    if (rValue<=(10)) {
        //8 --->1
        random=12;
    }else if (rValue<=(100)){
        //3---->1
        random = 9;
    }else if (rValue<=(590)){
        //0.5--->2
        NSArray *arr = @[@2,@5];
        NSInteger r= (arc4random()%2);
        random = [arr[r] floatValue];
    }else {
        //0.1--->3
        NSArray *arr = @[@3,@7,@11];
        NSInteger r= (arc4random()%3);
        random = [arr[r] floatValue];
    }
    //设置动画#define kCenterValue (1.0/24.0)
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setFromValue:[NSNumber numberWithFloat:2*M_PI*(orign/12.0-(orign?(1.0/24.0):0))]];
    [spin setToValue:[NSNumber numberWithFloat:2*M_PI*(random/12.0-(1.0/24.0)+5)]];
    [spin setDuration:5];
    [spin setDelegate:self];//设置代理，可以相应animationDidStop:finished:函数，用以弹出提醒框
    //速度控制器
    [spin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    //添加动画
    [[image2 layer] addAnimation:spin forKey:nil];
    //锁定结束位置
    image2.transform = CGAffineTransformMakeRotation(2*M_PI*(random/12.0-(1.0/24.0)+5));
    //锁定fromValue的位置
    orign = random;
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //判断抽奖结果
    int integral;
    
    if (orign ==12) {
        integral = 800;
    }else if (orign == 9)
    {
        integral = 300;
    }else if (orign ==5 || orign == 2)
    {
        integral = 500;
    }else if (orign == 3 ||orign == 7 || orign == 11)
    {
        integral = 100;
    }else
    {
        integral = 0;
    }
    btn_start.enabled = YES;
    
    if(integral >0){
        NSString *newIncome = [NSString stringWithFormat:@"%d",[[CBKeyChain load:INCOME]intValue]+integral];
        NSString *newTotal = [NSString stringWithFormat:@"%d",[[CBKeyChain load:TOTOLINTEGRAL] intValue]+integral];
        [CBKeyChain save:INCOME data:newIncome];
        [CBKeyChain save:TOTOLINTEGRAL data:newTotal];
        [[RecordManager sharedRecordManager]updateRecordWithContent:@"签到抽奖" andIntegral:[NSString stringWithFormat:@"+%d",integral]];
        //通知刷新积分
        [NOTIFICATION_CENTER postNotificationName:@"UpdateIntegral" object:nil];

        //更新bmob Users表
        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
        [bquery getObjectInBackgroundWithId:[CBKeyChain load:USERID] block:^(BmobObject *object,NSError *error){
            if (!error) {
                if (object) {
                    [object setObject:newTotal forKey:TOTOLINTEGRAL];
                    [object updateInBackground];
                }
            }else{
            }
        }];
        
        //上传bmob IncomeRecord表
        BmobObject *gameScore = [BmobObject objectWithClassName:@"IncomeRecord"];
        [gameScore setObject:[CBKeyChain load:USERID] forKey:@"userId"];
        [gameScore setObject:@"签到抽奖" forKey:@"type"];
        [gameScore setObject:[NSString stringWithFormat:@"%d",integral] forKey:@"integral"];
        [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
        }];

    }
    
    MBAlertView *alert = [MBAlertView alertWithBody:[NSString stringWithFormat:@"恭喜你，抽中%d积分",integral] cancelTitle:@"好的" cancelBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addToDisplayQueue];

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
