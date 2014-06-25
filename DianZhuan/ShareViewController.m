//
//  ShareViewController.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-23.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "ShareViewController.h"
#import <ShareSDK/ShareSDK.h>
@interface ShareViewController ()

@end

@implementation ShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"分享";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _inviteId.text = [CBKeyChain load:USERID];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)copy:(id)sender {
    NSString *wapurl = _inviteId.text;
    [UIPasteboard generalPasteboard].string = wapurl;
    [MBHUDView hudWithBody:@"复制成功" type:MBAlertViewHUDTypeCheckmark hidesAfter:1.5 show:YES];

}

- (IBAction)share:(id)sender {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"AppIcon"  ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"我正在玩一个能够赚钱的神器#金手指#,五分钟就能赚十元钱,支持提现到支付宝或手机充值，赶紧下一个吧！\n下载地址：\nhttp://jinshouzhi.bmob.cn"
                                       defaultContent:@"金手指-手机赚钱神器"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"金手指-手机赚钱神器"
                                                  url:@"http://jinshouzhi.bmob.cn"
                                          description:@"五分钟就能赚十元钱,支持提现到支付宝或手机充值"
                                            mediaType:SSPublishContentMediaTypeNews];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    [self updateIntegralWithShareType:type];
                                    
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    [MBHUDView hudWithBody:@"分享失败" type:MBAlertViewHUDTypeExclamationMark hidesAfter:1.5 show:YES];
                                }
                            }];
}

- (void)updateIntegralWithShareType:(int)shareType{
    NSString *shareName;
    switch (shareType) {
        case 1:  //新浪微博
            shareName = @"新浪微博分享成功";
            break;
        case 6:  //qq空间
            shareName = @"QQ空间分享成功";
            break;
        case 22:  //微信好友
            shareName = @"微信好友分享成功";
            break;
        case 23:  //微信朋友
            shareName = @"微信朋友圈分享成功";
            break;
        case 24:  //QQ
            shareName = @"QQ分享成功";
            break;
        case 37:  //微信收藏
            shareName = @"微信收藏分享成功";
            break;
    }
    [MBHUDView hudWithBody:shareName type:MBAlertViewHUDTypeCheckmark hidesAfter:1.5 show:YES];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[USER_DEFAULT objectForKey:@"ShareTypes"]];
    if(![array containsObject:[NSString stringWithFormat:@"%d",shareType]]){
        [array addObject:[NSString stringWithFormat:@"%d",shareType]];
        [USER_DEFAULT setObject:array forKey:@"ShareTypes"];
        
        
        NSString *newTotalIntegral = [NSString stringWithFormat:@"%d",[[CBKeyChain load:TOTOLINTEGRAL] intValue]+50];
        NSString *newIncome = [NSString stringWithFormat:@"%d",[[CBKeyChain load:INCOME] intValue]+50];
        [CBKeyChain save:TOTOLINTEGRAL data:newTotalIntegral];
        [CBKeyChain save:INCOME data:newIncome];
        [[RecordManager sharedRecordManager]updateRecordWithContent:shareName andIntegral:@"+50"];
        
        [NOTIFICATION_CENTER postNotificationName:@"UpdateIntegral" object:nil];
        
        //上传bmob IncomeRecord表
        BmobObject *gameScore = [BmobObject objectWithClassName:@"IncomeRecord"];
        [gameScore setObject:[CBKeyChain load:USERID] forKey:@"userId"];
        [gameScore setObject:shareName forKey:@"type"];
        [gameScore setObject:@"50" forKey:@"integral"];
        [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        }];
    }
    
}
@end
