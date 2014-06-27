//
//  Utility.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-16.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (NSString *)getRandomNumber:(int)from to:(int)to{
    return [NSString stringWithFormat:@"%d", (int)(from + (arc4random() % (to - from + 1)))]; //+1,result is [from to]; else is [from, to)!!!!!!!
}

+(NSString *)getCurrentTime{
    
    //实例化一个NSDateFormatter对象
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    //用[NSDate date]可以获取系统当前时间
    //[dateFormatter setDateFormat:@"MM月dd日  HH:mm"];
    
    
    NSDate *date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:date];
    
    NSString *minute = [NSString stringWithFormat:@"%d",[components minute]];
    
    static NSInteger tmpMinute = -1;
    if(([minute doubleValue] - tmpMinute<1)||([minute doubleValue] - tmpMinute==59)){
        return @"";
    }
    tmpMinute = [minute integerValue];
    DLog(@"tmpMinute %d",tmpMinute);
    if([components minute]<=9){
        minute = [NSString stringWithFormat:@"0%d",[components minute]];
    }
    NSString *currentDateStr = [NSString stringWithFormat:@"%d月%d日 %d:%@",[components month],[components day],([components hour]<12)?[components hour]:[components hour]-12,minute];
    
    
    return currentDateStr;
}

//判断当前时间和服务端时间间隔
+ (BOOL)isTodayDateWithData:(NSDate *)localDate otherDate:(NSDate *)serverDate{
    //NSDate存储的是世界标准时(UTC),和本地间隔八小时，输出时需要根据时区转换为本地时间

    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDate *newLocalDate = [localDate  dateByAddingTimeInterval: [zone secondsFromGMTForDate: localDate]];
    NSDate *newServerDate = [serverDate  dateByAddingTimeInterval: [zone secondsFromGMTForDate: serverDate]];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:newLocalDate  toDate:newServerDate  options:0];
    int days = [comps day];
    
    if(days==0){
        NSDate *recordDate = [USER_DEFAULT objectForKey:RECORDDATE];
        if(recordDate){
            NSDateComponents *tmpComps = [gregorian components:unitFlags fromDate:recordDate  toDate:newServerDate  options:0];
            if([tmpComps day]<=0){
                return NO;
            }
        }
        return YES;
    }else{
        return NO;
    }
}


@end
