//
//  UIImage+Addition.h
//  Mejust_Business
//
//  Created by 时代合盛 on 14-1-8.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addition)

+(UIImage *)imageWithFileName:(NSString *)imageName;

+(UIImage *)imageWithFileName:(NSString *)imageName type:(NSString *)type;

- (UIImage *)scaleToSize:(CGSize)size;


- (UIImage *)imageCroppedToRect:(CGRect)rect;

- (UIImage *)squareImage;

+(UIImage *)imageWithColor:(UIColor *)color;

@property (nonatomic, assign, readonly) NSInteger rightCapWidth;
@property (nonatomic, assign, readonly) NSInteger bottomCapHeight;

@end
