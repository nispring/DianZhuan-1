//
//  main.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-5.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CBAppDelegate.h"

int main(int argc, char * argv[])
{
    [Bmob registerWithAppKey:@"447f5583fecded5394a08389164bcfc5"];
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([CBAppDelegate class]));
    }
}
