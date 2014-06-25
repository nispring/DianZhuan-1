//
//  QuestionViewController.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-11.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "QuestionViewController.h"
#import "QuestionCell.h"
@interface QuestionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)NSArray *dataArray;

@end

@implementation QuestionViewController

- (void)loadView{
    [super loadView];
    self.title = @"常见问题";
    
    self.dataArray = @[@{@"title":@"联系我们",@"content":@"客服QQ:541100185\n工作时间:周一至周五 9:00-18:00(节假日休息)\n\n开始任务前，请先仔细阅读完成任务的条件"},@{@"title":@"金币值多少钱",@"content":@"1金币约等于1元人民币，部分兑换更划算，详情请留意兑换的消耗金额"},@{@"title":@"为什么能赚钱",@"content":@"用户完成广告联盟商指定的任务，即完成了广告推行行为，获得相应报酬，此奖奖励为劳动所得，有广告联盟商支付相应报酬"},@{@"title":@"手机充值，支付宝兑换",@"content":@"目前只支持--对应的方式进行兑换，进行兑换的支付宝账号必须是经过实名认证的，未经过实名认证的账号暂时无法兑换，金额将退回到您的账户中"},@{@"title":@"没有获得积分怎么办？",@"content":@"请检查是否按要求完成了任务，如\n1.必须首次安装，以前安装过，删除再安装无效\n2.必须完成任务的要求，比如注册，体验分钟数等\n3.不同联盟商里的相同任务，只能做一次，重复无效，如果确认没有问题，请向我们投诉该广告联盟商，我们将定期更换可信的广告商"}];

    self.table = [[UITableView alloc]init];
    [self.view addSubview:self.table];
    self.table.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT-64);
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.tableFooterView = [[UIView alloc]init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DLog(@"222");
    QuestionCell *cell = (QuestionCell *)[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if(cell == nil){
         cell = [[[NSBundle mainBundle] loadNibNamed:@"QuestionCell" owner:self options:nil] lastObject];
    }
    cell.titleLabel.text = _dataArray[indexPath.row][@"title"];

    NSString *text = _dataArray[indexPath.row][@"content"];
    //同上面的
    CGSize constraint = CGSizeMake(300, 2000);
    CGSize size= [text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
    cell.contentLabel.frame = CGRectMake(cell.contentLabel.left, cell.contentLabel.top, 300, size.height);
    cell.contentLabel.text = text;

    cell.height = cell.contentLabel.bottom+10;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:_table cellForRowAtIndexPath:indexPath];
    return cell.height;
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
