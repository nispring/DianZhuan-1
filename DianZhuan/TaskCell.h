//
//  TaskCell.h
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-13.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end
