//
//  BaseNavigationController+Rotation.m
//  XFGJ
//
//  Created by liyuchang on 15-1-23.
//  Copyright (c) 2015年 com.Vacn. All rights reserved.
//

#import "BaseNavigationController+Rotation.h""
@implementation BaseNavigationController (Rotation)
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
