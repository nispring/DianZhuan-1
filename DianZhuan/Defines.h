//
//  Defines.h
//  MiJia
//
//  Created by 时代合盛 on 14-3-13.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#ifndef MiJia_Defines_h
#define MiJia_Defines_h



#define APP_SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define APP_SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height
#define APP_SCREEN_CONTENT_HEIGHT   ([UIScreen mainScreen].bounds.size.height-20.0f)
#define NAVIGATIONBAR_HEIGHT 44.0f
#define STATUEBAR_HEIGHT 20.0f

#define IOS_7 ([[[UIDevice currentDevice] systemVersion]floatValue]>=7.0? YES:NO)
#define IS_4_INCH                   (APP_SCREEN_HEIGHT > 480.0)

#define USER_DEFAULT                [NSUserDefaults standardUserDefaults]
#define NOTIFICATION_CENTER         [NSNotificationCenter defaultCenter]

#define USERID @"userId"
#define YOUMI @"youmi"
#define CHUKONG @"chukong"
#define DUOMENG @"duomeng"
#define WANPU @"wanpu"
#define MOPAN @"mopan"
#define TOTOLINTEGRAL @"totalIntegral"
#define INCOME @"income"
#define EXPEND @"expend"
#define INVITE @"invite"

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#endif
