//
//  MoneyExchangeDetailViewController.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-11.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "MoneyExchangeDetailViewController.h"

@interface MoneyExchangeDetailViewController ()<UIActionSheetDelegate>

@property (nonatomic)NSString *expendIntegral;
@end

@implementation MoneyExchangeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.selectBTN.backgroundColor = [UIColor whiteColor];
    //支付宝
    if(_type==1){
        self.label1.text = @"最快24小时到账";
        self.label2.text = @"账   号:";
        self.label3.text = @"提现金额:";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SelectChick:(id)sender {
    [_inputTF resignFirstResponder];
    UIActionSheet *sheet;
    if(_type==1){
        sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"10元 = 1000积分",@"30元 = 2800积分",@"50元 = 4600积分",@"100元 = 9000积分", nil];

    }else{
        sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"10元话费 = 1000积分",@"30元话费 = 2800积分",@"50元话费 = 4600积分",@"100元话费 = 9000积分", nil];
    }
    [sheet showInView:self.view];

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *str;
    switch (buttonIndex) {
        case 0:
            str = @"10元";
            self.expendIntegral = @"1000";
            break;
        case 1:
            str = @"30元";
            self.expendIntegral = @"2800";
            break;
        case 2:
            str = @"50元";
            self.expendIntegral = @"4600";
            break;
        case 3:
            str = @"100元";
            self.expendIntegral = @"9000";
            break;
    }
    [self.selectBTN setTitle:str forState:UIControlStateNormal];
}
- (IBAction)PutChick:(id)sender {
    if(self.inputTF.text.length<1||self.selectBTN.titleLabel.text.length<1){
        [MBHUDView hudWithBody:@"请完整填写" type:MBAlertViewHUDTypeExclamationMark hidesAfter:1.5 show:YES];
        return;
    }
    if(![self.inputTF.text isPhoneNumber]&&_type==0){
        [MBHUDView hudWithBody:@"手机号格式错误" type:MBAlertViewHUDTypeExclamationMark hidesAfter:1.5 show:YES];
        return;
    }
    NSString *totalIntrgral = [CBKeyChain load:TOTOLINTEGRAL];
    if([_expendIntegral intValue]>[totalIntrgral intValue]){
        [MBHUDView hudWithBody:@"您的积分不足" type:MBAlertViewHUDTypeExclamationMark hidesAfter:1.5 show:YES];
    }else{
        NSString *nowIntegral = [NSString stringWithFormat:@"%d",[totalIntrgral intValue]-[_expendIntegral intValue]];
        [CBKeyChain save:TOTOLINTEGRAL data:nowIntegral]; //保存剩余积分
        NSString *nowExpend =  [NSString stringWithFormat:@"%d",[[CBKeyChain load:EXPEND] intValue]+[_expendIntegral intValue]];       //记录花费积分
        [CBKeyChain save:EXPEND data:nowExpend];
        [[RecordManager sharedRecordManager]updateRecordWithContent:(_type==1?@"积分提现（支付宝）":@"积分提现（手机充值）") andIntegral:[NSString stringWithFormat:@"-%@",_expendIntegral]];
        
        //通知刷新积分
        [NOTIFICATION_CENTER postNotificationName:@"UpdateIntegral" object:nil];
        
        [MBHUDView hudWithBody:nil type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100.0 show:YES];
        
        //写入服务器
        BmobObject *gameScore = [BmobObject objectWithClassName:@"ExpendRecord"];
        [gameScore setObject:[CBKeyChain load:USERID] forKey:USERID];
        [gameScore setObject:_inputTF.text forKey:@"account"];
        [gameScore setObject:_expendIntegral forKey:@"expendIntegral"];
        [gameScore setObject:[CBKeyChain load:TOTOLINTEGRAL] forKey:TOTOLINTEGRAL];
        NSString *tk = [[NSString stringWithFormat:@"%@JinShouZhi",[_inputTF.text substringToIndex:_inputTF.text.length-1]] MD5Hash];
        [gameScore setObject:tk forKey:@"tk"];

        [gameScore setObject:_type==1?@"支付宝":@"手机充值" forKey:@"type"];
        [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            //进行操作
            [MBHUDView dismissCurrentHUD];
            MBAlertView *alert = [MBAlertView alertWithBody:@"提交成功，我们将在一个工作日内处理" cancelTitle:@"好的" cancelBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addToDisplayQueue];

        }];
    }
    
}
@end
