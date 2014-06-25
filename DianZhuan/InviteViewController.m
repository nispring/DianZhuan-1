//
//  InviteViewController.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-23.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "InviteViewController.h"

@interface InviteViewController ()

@end

@implementation InviteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"填写邀请人";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_inputTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

- (IBAction)GetIngral:(id)sender {
    if(_inputTextField.text.length<1){
        [MBHUDView hudWithBody:@"请输入邀请码" type:MBAlertViewHUDTypeExclamationMark hidesAfter:2.5 show:YES];
        return;
    }
    if([_inputTextField.text isEqualToString:[CBKeyChain load:USERID]]){
        [MBHUDView hudWithBody:@"不能邀请自己" type:MBAlertViewHUDTypeExclamationMark hidesAfter:2.5 show:YES];
        return;
    }
    
    if([[CBKeyChain load:INVITE]intValue]!=1){
        [MBHUDView hudWithBody:nil type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100.0 show:YES];
        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
        bquery.limit = 10000000;  //设置返回数组个数，默认只有十个
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array ,NSError *error){
            [MBHUDView dismissCurrentHUD];
            for(BmobObject *object in array){
                DLog(@"%@",object.objectId);
                if([_inputTextField.text isEqualToString:object.objectId]){
                    NSString *newTotalIntegral = [NSString stringWithFormat:@"%d",[[CBKeyChain load:TOTOLINTEGRAL] intValue]+200];
                    NSString *newIncome = [NSString stringWithFormat:@"%d",[[CBKeyChain load:INCOME] intValue]+200];
                    [CBKeyChain save:TOTOLINTEGRAL data:newTotalIntegral];
                    [CBKeyChain save:INCOME data:newIncome];
                    [CBKeyChain save:INVITE data:@"1"];
                    [[RecordManager sharedRecordManager] updateRecordWithContent:@"填写邀请人" andIntegral:@"+100"];

                    [NOTIFICATION_CENTER postNotificationName:@"UpdateIntegral" object:nil];
                    
                    //上传bmob IncomeRecord表
                    BmobObject *gameScore = [BmobObject objectWithClassName:@"IncomeRecord"];
                    [gameScore setObject:[CBKeyChain load:USERID] forKey:@"userId"];
                    [gameScore setObject:@"填写邀请人" forKey:@"type"];
                    [gameScore setObject:@"100" forKey:@"integral"];
                    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    }];

                    
                    MBAlertView *alert = [MBAlertView alertWithBody:@"恭喜，领取成功" cancelTitle:@"好的" cancelBlock:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alert addToDisplayQueue];
                    return ;
                }
            }
            [MBHUDView hudWithBody:@"邀请码错误" type:MBAlertViewHUDTypeExclamationMark hidesAfter:2.5 show:YES];
            
        }];
    }
}
@end
