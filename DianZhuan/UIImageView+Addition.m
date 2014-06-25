//
//  UIImageView+Addition.m
//  Mejust_Business
//
//  Created by 时代合盛 on 14-1-16.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "UIImageView+Addition.h"

@implementation UIImageView (Addition)

- (void)autoResizeFrame{
    self.clipsToBounds = YES;
    self.contentMode =  UIViewContentModeScaleAspectFill;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}
@end
