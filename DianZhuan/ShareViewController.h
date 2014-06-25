//
//  ShareViewController.h
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-23.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "FatherViewController.h"

@interface ShareViewController : FatherViewController
@property (weak, nonatomic) IBOutlet UILabel *inviteId;
- (IBAction)copy:(id)sender;
- (IBAction)share:(id)sender;


@end
