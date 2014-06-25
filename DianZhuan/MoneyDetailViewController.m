//
//  MoneyDetailViewController.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-11.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "MoneyDetailViewController.h"
#import "MoneyDetailTopCell.h"
@interface MoneyDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)MoneyDetailTopCell *moneyDetailTopCell;
@property (nonatomic,strong)UIRefreshControl *refreshControl;

@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation MoneyDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收支明细";
    
    self.dataArray = [[NSMutableArray alloc]initWithArray:[[RecordManager sharedRecordManager]loadRecord]];
    DLog(@"%@",_dataArray);
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MoneyDetailTopCell"owner:self options:nil];
    self.moneyDetailTopCell = [nib objectAtIndex:0];
    self.moneyDetailTopCell.totalLabel.text = [CBKeyChain load:TOTOLINTEGRAL];
    self.moneyDetailTopCell.incomeLabel.text = [CBKeyChain load:INCOME];
    self.moneyDetailTopCell.expendLabel.text = [CBKeyChain load:EXPEND];

    
    UITableView *table = [[UITableView alloc]init];
    [self.view addSubview:table];
    table.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT-64);
    table.dataSource = self;
    table.delegate = self;
    table.backgroundColor = [UIColor clearColor];
    table.tableFooterView = [[UIView alloc]init];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    if(indexPath.row==0){
        [cell.contentView addSubview:_moneyDetailTopCell];
    }else{
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.text = _dataArray[indexPath.row-1][@"content"] ;
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.textLabel.font = [UIFont systemFontOfSize:11];
        cell.detailTextLabel.text = _dataArray[indexPath.row-1][@"integral"];
    }
    cell.selectionStyle = 0;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return self.moneyDetailTopCell.height;
    }else{
        return 50;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
