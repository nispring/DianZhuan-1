//
//  RecordManager.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-16.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "RecordManager.h"
#import "SINGLETON_GCD.h"

@implementation RecordManager
SINGLETON_GCD(RecordManager);


- (NSMutableArray *)loadRecord{
    NSMutableArray *tmpArray = [[NSMutableArray alloc]initWithArray:[USER_DEFAULT objectForKey:[CBKeyChain load:USERID]]];
    return tmpArray;
}
- (void)updateRecordWithContent:(NSString *)content andIntegral:(NSString *)integral{
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc]initWithArray:[USER_DEFAULT objectForKey:[CBKeyChain load:USERID]]];
    NSDictionary *dic = @{@"content":content,@"integral":integral,@"time":[Utility getCurrentTime]};
    if(tmpArray.count>0){
        [tmpArray insertObject:dic atIndex:0];
        [USER_DEFAULT setObject:tmpArray forKey:[CBKeyChain load:USERID]];
    }else{
        NSMutableArray *array = [NSMutableArray arrayWithObject:dic];
        [USER_DEFAULT setObject:array forKey:[CBKeyChain load:USERID]];
    }
    [USER_DEFAULT synchronize];
}

@end
