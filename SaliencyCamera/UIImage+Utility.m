//
//  UIImage+Utility.m
//  SaliencyCamera
//
//  Created by 加藤 亮太 on 2013/11/10.
//  Copyright (c) 2013年 Ryota Katoh. All rights reserved.
//

#import "UIImage+Utility.h"

@implementation UIImage (Utility)

#pragma comment リサイズ関数を記述
- (UIImage *)resize:(CGRect)rect{
    UIGraphicsBeginImageContext(rect.size);
    
    [self drawInRect:rect];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resizedImage;
    
}


@end
