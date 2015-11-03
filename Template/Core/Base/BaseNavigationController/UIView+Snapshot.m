//
//  UIView+Snapshot.m
//  FrameWork
//
//  Created by liyuchang on 15-1-19.
//  Copyright (c) 2015年 com.Vacn. All rights reserved.
//

#import "UIView+Snapshot.h"

@implementation UIView (Snapshot)
- (UIImage *)snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

@end
