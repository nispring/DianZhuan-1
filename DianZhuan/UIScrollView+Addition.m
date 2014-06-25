//
//  UIScrollView+Addition.m
//  Mejust_Business
//
//  Created by 时代合盛 on 14-1-24.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "UIScrollView+Addition.h"

@implementation UIScrollView (Addition)

- (void)scrollToBottomWitohAnimated:(BOOL)flag{
    CGPoint bottomOffset = CGPointMake(self.contentOffset.x, self.contentSize.height - self.bounds.size.height);
    if(flag){
        [self setContentOffset:bottomOffset animated:YES];
    }
    else{
        [self setContentOffset:bottomOffset animated:NO];
    }
}
@end
