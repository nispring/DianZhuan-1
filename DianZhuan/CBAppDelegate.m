//
//  CBAppDelegate.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-5.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "CBAppDelegate.h"
#import "MainViewController.h"
#import "YouMiConfig.h"
#import "PunchBoxAd.h"
#import "AppConnect.h"
#import "APService.h"

#import<ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import "LaunchViewController.h"
//mejust 首页
#import "FirstViewController.h"
@implementation CBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [NSThread sleepForTimeInterval:3];
    NSDictionary *dict=[NSDictionary dictionaryWithObjects:
                            [NSArray arrayWithObjects:[UIColor whiteColor],[UIFont boldSystemFontOfSize:20],[UIColor clearColor],nil] forKeys:
                            [NSArray arrayWithObjects:UITextAttributeTextColor,UITextAttributeFont,UITextAttributeTextShadowColor,nil]];
    [[UINavigationBar appearance] setTitleTextAttributes:dict];

    //极光推送
    [APService
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert)];
    [APService setupWithOption:launchOptions];
    [self initConfigWithOptions];

    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [UINavigationBar appearance].tintColor = [UIColor colorWithStr:@"B52020"];
    } else {
        [UINavigationBar appearance].barTintColor = [UIColor colorWithStr:@"B52020"];
    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    LaunchViewController *vc = [[LaunchViewController alloc]init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];

    
    MainViewController *mainVC = [[MainViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainVC];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        //保存在keychain
        [CBKeyChain save:TOTOLINTEGRAL data:@"100"];
        [CBKeyChain save:INCOME data:@"100"];
        [CBKeyChain save:EXPEND data:@"0"];
        [CBKeyChain save:INVITE data:@"0"];
        [CBKeyChain save:RECORDDATE data:@""];

        
        //上传bmob User表
        BmobObject *bmob = [BmobObject objectWithClassName:@"User"];
        [bmob setObject:@"100" forKey:TOTOLINTEGRAL];
        [bmob saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if(isSuccessful){
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
                //记录唯一标示用户
                [CBKeyChain save:USERID data:bmob.objectId];
                [[RecordManager sharedRecordManager] updateRecordWithContent:@"首次赠送积分" andIntegral:@"+100"];
                
                //为devicetoken添加别名 实现消息个推
                [APService setAlias:bmob.objectId callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];

            }
            
        }];
    }

    //应付苹果审核
//    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"AppStatus"];
//    [bquery getObjectInBackgroundWithId:@"37ts0001" block:^(BmobObject *object,NSError *error){
//            if (object) {
//                UIViewController *vc ;
//                NSString *status = [object objectForKey:@"enable"];
//                [status intValue]==0?(vc = [[FirstViewController alloc]init]):(vc = [[MainViewController alloc]init]);
//                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//                self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//                self.window.backgroundColor = [UIColor whiteColor];
//                self.window.rootViewController = nav;
//                [self.window makeKeyAndVisible];
//            }else{
//                [UIAlertView showAlertViewWithMessage:@"网络错误"];
//            }
//    }];
    
    return YES;
}

//为devicetoken添加别名 实现消息个推
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    
}

- (void)initConfigWithOptions{
    //shareSdk
    [ShareSDK registerApp:@"20c2d784a61f"];
    [self initializePlat];
    [self initializePlatForTrusteeship];

    //有米
    [YouMiConfig launchWithAppID:@"d92f75fb16b0b4c6" appSecret:@"ca7bb68f7bc2af0f"];
    
    //触控
    [PunchBoxAd startSession:@"820376262-3BB48B-ED3A-CAE4-AF3149C13"];
    
    //万普
    [AppConnect getConnect:@"38718de31b979ca9792dd462523c68c2" pid:@"appstore"];
}
- (void)initializePlat{
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"552358160"
                               appSecret:@"4802ceef3e4ae78442d10b20ee4e1375"
                             redirectUri:@"http://dianzhuan.bmob.cn"];
    //添加QQ空间应用
    [ShareSDK connectQZoneWithAppKey:@"101127381"
                           appSecret:@"332c9ac390b0a1d6909636edba11cf35"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //添加微信应用
    [ShareSDK connectWeChatWithAppId:@"wx8e9acd4aeb832e3d"
                           wechatCls:[WXApi class]];
}

- (void)initializePlatForTrusteeship{
    //导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
    [ShareSDK importWeChatClass:[WXApi class]];
    
    //导入QQ互联和QQ好友分享需要的外部库类型，如果不需要QQ空间SSO和QQ好友分享可以不调用此方法
    [ShareSDK importQQClass:[QQApiInterface class]
            tencentOAuthCls:[TencentOAuth class]];
    
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [APService handleRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
