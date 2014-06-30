//
//  MainViewController.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-5.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "MainViewController.h"
#import "CBAppDelegate.h"
#import "TurntableViewController.h"
#import "ScratchViewController.h"
#import "MoneyExchangeViewController.h"
#import "MoneyDetailViewController.h"
#import "QuestionViewController.h"
#import "TaskCell.h"
#import "MainTapCell.h"

#import "YouMiWall.h"
#import "YouMiPointsManager.h"
#import "PunchBoxAd.h"
#import "DMOfferWallManager.h"
#import "AppConnect.h"
#import "MopanAdWall.h"

#import "RNGridMenu.h"

#import "ShareViewController.h"
#import "InviteViewController.h"

#import "ScrollLabelView.h"
#import "AFHelper.h"
#import "BundleHelper.h"

@interface MainViewController ()<PBOfferWallDelegate,DMOfferWallManagerDelegate,MopanAdWallDelegate,RNGridMenuDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)DMOfferWallManager *dmManager;
@property (nonatomic,)MopanAdWall *MopanAdWall;

@property (nonatomic,strong)MainTapCell *mainTopCell;

@property (nonatomic,strong)TaskCell *taskCell;
@property (nonatomic,strong)ScrollLabelView *scrollLabel;
@property (nonatomic,strong)UIRefreshControl *refreshControl;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSString *notifiStr;
@end

@implementation MainViewController

- (void)loadView{
    [super loadView];
    self.title = @"金手指";
    if(IOS_7){
        self.edgesForExtendedLayout = 0;
    }
    UIButton *rightButton = [[UIButton alloc]init];
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.image = [UIImage imageNamed:@"menuButton"];
    imageview.frame = CGRectMake(0, 0, 25, 35);
    [rightButton addSubview:imageview];
    rightButton.frame = CGRectMake(0, 0, 25, 35);
    [rightButton addTarget:self action:@selector(doMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    self.dataArray =
    @[@{@"icon":@"adcenter",@"title":@"任务平台",@"subTitle":@"快来赚取积分吧"},
      @{@"icon":@"SignIn",@"title":@"每日签到"
        ,@"subTitle":@"转盘大抽奖，人品大爆发"},
      @{@"icon":@"share",@"title":@"邀请好友",@"subTitle":@"分享给好友，轻松得积分"},
      @{@"icon":@"invite",@"title":@"填写邀请人 "
        ,@"subTitle":@"轻松领取100积分"}
      ];

    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = [UIColor grayColor];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    
    self.mainTopCell = [[[NSBundle mainBundle]loadNibNamed:@"MainTopCell"owner:self options:nil] lastObject];
    self.mainTopCell.integralLabel.text = [CBKeyChain load:TOTOLINTEGRAL];
    self.mainTopCell.idLabel.text = [CBKeyChain load:USERID];
    self.mainTopCell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topCellBG"]];
    self.tableView.tableHeaderView = _mainTopCell;
    self.tableView.tableFooterView = [[UIView alloc]init];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //检测更新
    [self checkVersion];
    
    //有米
    [YouMiWall enable];
    [YouMiPointsManager enable];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(pointsGotted:) name:kYouMiPointsManagerRecivedPointsNotification object:nil];
    
    //触控
    [PBOfferWall sharedOfferWall].delegate = self;
    
    //多盟
    ;
    self.dmManager = [[DMOfferWallManager alloc]initWithPublisherID:@"96ZJ056QzeFWrwTBvy"];
    self.dmManager.delegate = self;
    
    //万普
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGetPointsSuccess:) name:WAPS_GET_POINTS_SUCCESS object:nil];
    
    //磨盘
    self.MopanAdWall = [[MopanAdWall alloc]initWithMopan:@"12703" withAppSecret:@"5vvayxpa9vfk3osl"];
    self.MopanAdWall.delegate = self;
    self.MopanAdWall.rootViewController = self;
    
    //刷新当前积分
    [NOTIFICATION_CENTER addObserver:self selector:@selector(UpdateIntegral) name:@"UpdateIntegral" object:nil];
 
    //首次进入自动刷新
    [self.tableView setContentOffset:CGPointMake(0, -75) animated:YES];
    [self.refreshControl beginRefreshing];
    [self refreshView:self.refreshControl];

}

- (void)doMenu{
    NSInteger numberOfOptions = 2;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"moneydetail"] title:@"收支明细"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"moneyexchange"] title:@"积分提现"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    av.menuView.tag = 101;
    av.cornerRadius = 0;
    av.menuStyle = RNGridMenuStyleGrid;
    [av showInViewController:self center:CGPointMake(160, 60)];
}
- (void)queryIntegral{
    //有米
    [YouMiPointsManager checkPoints];
    //触控
    [[PBOfferWall sharedOfferWall] queryRewardCoin:nil];
    //多盟
    [_dmManager checkOwnedPoint];
    //万普
    [AppConnect getPoints];
    //磨盘
    [_MopanAdWall getMoney];
}

- (void)UpdateIntegral{
    //查询积分
    [self queryIntegral];

    self.mainTopCell.idLabel.text = [CBKeyChain load:USERID];
    self.mainTopCell.integralLabel.text = [CBKeyChain load:TOTOLINTEGRAL];
    
}

-(void)handleData
{
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"AppStatus"];
    [bquery getObjectInBackgroundWithId:@"37ts0001" block:^(BmobObject *object,NSError *error){
        if (object) {
            //得到playerName和cheatMode
            self.notifiStr = [object objectForKey:@"notification"];
            if(self.scrollLabel){
                [self.scrollLabel removeFromSuperview];
            }
            if(_notifiStr.length>0){
                self.scrollLabel = [[ScrollLabelView alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 25) WithContent:_notifiStr];
                [self.view addSubview:_scrollLabel];
            }
            

            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM-dd hh:mm"];
            NSString *lastUpdated = [NSString stringWithFormat:@"上次刷新 %@", [formatter stringFromDate:[NSDate date]]];
            [self UpdateIntegral];
            self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];

        }
    }];
    
}
- (void)viewDidAppear:(BOOL)animated{
    if(self.scrollLabel){
        [self.scrollLabel removeFromSuperview];
    }
    if(_notifiStr.length>0){
        self.scrollLabel = [[ScrollLabelView alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 25) WithContent:_notifiStr];
        [self.view addSubview:_scrollLabel];
    }

}
-(void)refreshView:(UIRefreshControl *)refresh
{
    if (refresh.refreshing) {
        refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在刷新..."];
        [self performSelector:@selector(handleData) withObject:nil afterDelay:1];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskCell *taskCell = [[[NSBundle mainBundle] loadNibNamed:@"TaskCell" owner:self options:nil] lastObject];
    taskCell.icon.image = [UIImage imageNamed:_dataArray[indexPath.row][@"icon"]];
    taskCell.titleLabel.text = _dataArray[indexPath.row][@"title"];
    taskCell.subTitleLabel.text = _dataArray[indexPath.row][@"subTitle"];
    return taskCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self showGrid];
            break;
        case 1:
        {
            //获取bmob后台时间 为时间戳，需转换
            NSDate *serverDate = [NSDate dateWithTimeIntervalSince1970:[[Bmob getServerTimestamp] intValue]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            //服务器时间
            NSString *newServerDate = [dateFormatter stringFromDate:serverDate];
            //上次转盘时间
            NSString *turnDate = [CBKeyChain load:RECORDDATE];
            
            if(turnDate.length>0){
                if([turnDate isEqualToString:newServerDate]){
                    [MBHUDView hudWithBody:@"明天再来吧" type:MBAlertViewHUDTypeExclamationMark hidesAfter:2.5 show:YES];
                }else{
                    TurntableViewController *vc = [[TurntableViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
                TurntableViewController *vc = [[TurntableViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        }
        case 2:
        {
            ShareViewController *vc = [[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            if([[CBKeyChain load:INVITE]intValue]!=1){
                InviteViewController *vc = [[InviteViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [MBHUDView hudWithBody:@"你已经领取过了" type:MBAlertViewHUDTypeExclamationMark hidesAfter:2.5 show:YES];
            }
        }
            break;
    }
}
- (void)showGrid {
    NSInteger numberOfOptions = 5;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_youmi"] title:@"有米平台"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_chukong"] title:@"触控平台"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_duomeng"] title:@"多盟平台"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_wanpu"] title:@"万普平台"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_mopan"] title:@"磨盘平台"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    av.menuView.tag = 100;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}
- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    NSLog(@"Dismissed with item %d: %@", itemIndex, item.title);
    if(gridMenu.menuView.tag == 100){
        switch (itemIndex) {
            case 0:
                [YouMiWall showOffers:YES didShowBlock:^{
                    NSLog(@"已显示");
                } didDismissBlock:^{
                    NSLog(@"已退出");
                }];
                break;
            case 1:
                [[PBOfferWall sharedOfferWall] showOfferWallWithScale:0.9f];
                break;
            case 2:
                [_dmManager presentOfferWallWithViewController:self type:eDMOfferWallTypeList];
                break;
            case 3:
                [AppConnect showOffers:self];
                break;
            case 4:
                [_MopanAdWall showAppOffers];
                break;
        }
    }
    if(gridMenu.menuView.tag == 101){
        UIViewController *vc;
        switch (itemIndex) {
            case 0:{
                vc = [[MoneyDetailViewController alloc]init];
            }
                break;
            case 1:{
                vc = [[MoneyExchangeViewController alloc]init];
            }
                break;
            case 2:{
                vc = [[QuestionViewController alloc]init];
            }
            break;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//有米 回调
- (void)pointsGotted:(NSNotification *)notification {

    NSString *integral = [NSString stringWithFormat:@"%d",*[YouMiPointsManager pointsRemained]];
    
    NSLog(@"有米总积分：%@",integral);

    [self updateIntegralWithADType:1 andIntegral:integral];

}

//触控回调
/**
 *	@brief	用户完成积分墙任务的回调
 *
 *	@param 	pbOfferWall 	pbOfferWall
 *	@param 	taskCoins 	taskCoins中的元素为NSDictionary类型（taskCoins为空表示无积分返回，为nil表示查询出错）
 *                            键值说明：taskContent  NSString   任务名称
 //                                   coins        NSNumber    赚得金币数量
 *	@param 	error 	taskCoins为nil时有效，查询失败原因
 */
- (void)pbOfferWall:(PBOfferWall *)pbOfferWall queryResult:(NSArray *)taskCoins
          withError:(NSError *)error
{
    int totalCoins=0;
    for(NSDictionary *dic in taskCoins){
        totalCoins += [dic[@"coins"]intValue];
    }
    NSString *integral = [NSString stringWithFormat:@"%d",totalCoins];
    NSLog(@"触控总积分：%@",integral);

    [self updateIntegralWithADType:2 andIntegral:integral];

}
//多盟
// 积分查询成功之后,回调该接⼝口,获取总积分和总已消费积分。
- (void)dmOfferWallManager:(DMOfferWallManager *)manager
        receivedTotalPoint:(NSNumber *)totalPoint
        totalConsumedPoint:(NSNumber *)consumedPoint{
    
    NSString *integral = [NSString stringWithFormat:@"%@",totalPoint];
    NSLog(@"多盟总积分：%@",integral);

    [self updateIntegralWithADType:3 andIntegral:integral];

}

//万普通知
-(void)onGetPointsSuccess:(NSNotification*)notifyObj{
    WapsUserPoints *userPoints = notifyObj.object;
    NSString *integral = [NSString stringWithFormat:@"%d",[userPoints getPointsValue]];
    
    DLog(@"万普积分:%@",integral);
    [self updateIntegralWithADType:4 andIntegral:integral];

}

//磨盘
// 请求积分值成功后调用
//
// 详解:当接收服务器返回的积分值成功后调用该函数
// 补充：totalMoney: 返回用户的总积分
//      moneyName  : 返回的积分名称
- (void)adwallSuccessGetMoney:(NSInteger)totalMoney forMoneyName:(NSString*)moneyName
{
    NSLog(@"磨盘总积分：%d",(int)totalMoney);
    NSString *integral = [NSString stringWithFormat:@"%d",totalMoney];
    [self updateIntegralWithADType:5 andIntegral:integral];
}
- (void)adwallDidShowAppsStartLoad{
    
}
- (void)adwallDidShowAppsClosed{
    
}

- (void)updateIntegralWithADType:(int)adType andIntegral:(NSString *)newIntegral{
    NSString *oldIntegral;
    NSString *adName;
    NSString *adId;
    //有米（1）触控（2）多盟（3）万普（4）磨盘（5）
    switch (adType) {
        case 1:
            oldIntegral = [CBKeyChain load:YOUMI];
            adName = @"有米平台";
            adId = YOUMI;
            break;
        case 2:
            oldIntegral = [CBKeyChain load:CHUKONG];
            adName = @"触控平台";
            adId = CHUKONG;
            break;
        case 3:
            oldIntegral = [CBKeyChain load:DUOMENG];
            adName = @"多盟平台";
            adId = DUOMENG;
            break;
        case 4:
            oldIntegral = [CBKeyChain load:WANPU];
            adName = @"万普平台";
            adId = WANPU;
            break;
        case 5:
            oldIntegral = [CBKeyChain load:MOPAN];
            adName = @"磨盘平台";
            adId = MOPAN;
            break;
    }
    //如果该平台获取到得积分大于keychai中积分
    NSString *subStr = [NSString stringWithFormat:@"%d",[newIntegral intValue]-[oldIntegral intValue]];
    DLog(@"%@",[CBKeyChain load:WANPU]);
    if([subStr intValue] > 0){
        
        //提示用户获得多少积分
        [UIAlertView showAlertViewWithMessage:[NSString stringWithFormat:@"恭喜获得%@ %@积分",adName,subStr]];
        
        //保存在keychain  总积分 和对应平台积分
        NSString *newTotalIntegral = [NSString stringWithFormat:@"%d",[[CBKeyChain load:TOTOLINTEGRAL] intValue]+[subStr intValue]];
        [CBKeyChain save:TOTOLINTEGRAL data:newTotalIntegral];
        [CBKeyChain save:adId data:newIntegral];
        [[RecordManager sharedRecordManager] updateRecordWithContent:adName andIntegral:[NSString stringWithFormat:@"+%@",subStr]];
        
        //通知刷新积分
        [NOTIFICATION_CENTER postNotificationName:@"UpdateIntegral" object:nil];
        
        //更新bmob Users表
        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"User"];
        [bquery getObjectInBackgroundWithId:[CBKeyChain load:USERID] block:^(BmobObject *object,NSError *error){
            if (!error) {
                if (object) {
                    [object setObject:subStr forKey:adId];
                    [object setObject:newTotalIntegral forKey:TOTOLINTEGRAL];
                    [object updateInBackground];
                }
            }else{
            }
        }];
        
        //上传bmob IncomeRecord表
        BmobObject *gameScore = [BmobObject objectWithClassName:@"IncomeRecord"];
        [gameScore setObject:[CBKeyChain load:USERID] forKey:@"userId"];
        [gameScore setObject:adName forKey:@"type"];
        [gameScore setObject:subStr forKey:@"integral"];
        [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
        }];
    }
}



//检测更新
- (void)checkVersion{
    [AFHelper downDataWithViewController:self Dictionary:nil andBaseURLStr:@"http://itunes.apple.com/" andPostPath:@"lookup?id=893523283" success:^(NSDictionary *dic){
        NSArray *configData = [dic valueForKey:@"results"];
        NSString *version;
        for (id config in configData)
        {
            version = [config valueForKey:@"version"];
        }
        NSString *oldVersion = [BundleHelper bundleShortVersionString];
        if ([version isEqualToString:oldVersion])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"有新版本啦" message:nil delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"立即更新", nil];
            [alert show];
        }else{
        }
    }];
}
#pragma mark uialertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        NSString *iTunesLink = @"https://itunes.apple.com/us/app/jin-shou-zhipro/id893523283?l=zh&ls=1&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
