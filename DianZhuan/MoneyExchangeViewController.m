//
//  MoneyExchangeViewController.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-11.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "MoneyExchangeViewController.h"
#import "MoneyExchangeDetailViewController.h"
@interface MoneyExchangeViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MoneyExchangeViewController

- (void)loadView{
    [super loadView];
    self.title = @"现金提取";
    
    UITableView *table = [[UITableView alloc]init];
    [self.view addSubview:table];
    table.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT-64);
    table.dataSource = self;
    table.delegate = self;
    table.rowHeight = 70.0f;
    table.tableFooterView = [[UIView alloc]init];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
    }
    cell.textLabel.text = indexPath.row==0?@"话费充值":@"支付宝提取";
    cell.detailTextLabel.text = indexPath.row==0?@"快速充值，充得多送得多":@"直接提现，快速安全";
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MoneyExchangeDetailViewController *vc = [[MoneyExchangeDetailViewController alloc]initWithNibName:@"MoneyExchangeDetailViewController" bundle:nil];
    vc.title = indexPath.row==0?@"话费充值":@"支付宝提现";
    vc.type = indexPath.row==0?0:1;
    [self.navigationController pushViewController:vc animated:YES];
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
