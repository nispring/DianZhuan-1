//
//  ScrollLabelView.h
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-25.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollLabelView : UIView
@property (nonatomic,strong)UILabel *label;

- (id)initWithFrame:(CGRect)frame WithContent:(NSString *)content;
@end
