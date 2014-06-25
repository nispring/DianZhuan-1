//
//  RecordManager.h
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-16.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordManager : NSObject

+ (RecordManager *)sharedRecordManager;

- (NSMutableArray *)loadRecord;

- (void)updateRecordWithContent:(NSString *)content andIntegral:(NSString *)integral;

@end
