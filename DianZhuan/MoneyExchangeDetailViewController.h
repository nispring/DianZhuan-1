//
//  MoneyExchangeDetailViewController.h
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-11.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "FatherViewController.h"

@interface MoneyExchangeDetailViewController : FatherViewController


@property (nonatomic)int type;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;


@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UIButton *selectBTN;

- (IBAction)SelectChick:(id)sender;
- (IBAction)PutChick:(id)sender;

@end
