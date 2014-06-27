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
        self.label = [[UILabel alloc]init];
        self.label.frame = CGRectMake(self.width+25, 0, content.length*15, self.height);
        [self addSubview:_label];
        
        
        self.label.font = [UIFont boldSystemFontOfSize:13];
        self.label.text = content;
        self.label.textColor = [UIColor blackColor];
        self.label.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"notification"];
        imageView.frame = CGRectMake(self.label.left-25, 2.5, 20, 20);
        [self addSubview:imageView];
        
        
        CGRect frame = _label.frame;
        [UIView beginAnimations:@"testAnimation"context:NULL];
        [UIView setAnimationDuration:12.0f];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationRepeatCount:999999];
        frame = _label.frame;
        frame.origin.x = -frame.size.width;
        _label.frame = frame;
        imageView.frame = CGRectMake(_label.left-25, 2.5, 20, 20);
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
