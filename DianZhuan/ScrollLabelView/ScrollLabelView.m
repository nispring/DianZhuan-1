//
//  ScrollLabelView.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-25.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "ScrollLabelView.h"

@implementation ScrollLabelView
- (id)initWithFrame:(CGRect)frame WithContent:(NSString *)content{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(self.width+25, 0, content.length*15, self.height);
        [self addSubview:label];
        label.font = [UIFont boldSystemFontOfSize:13];
        label.text = content;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"notification"];
        imageView.frame = CGRectMake(-25, 2.5, 20, 20);
        [label addSubview:imageView];
        
        CGRect frame = label.frame;
        [UIView beginAnimations:@"testAnimation"context:NULL];
        [UIView setAnimationDuration:12.0f];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationRepeatCount:999999];
        frame = label.frame;
        frame.origin.x = -frame.size.width;
        label.frame = frame;

        [UIView commitAnimations];
    }
    return self;

}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
