//
//  IOS7ViewControllerAnimateTransform.h
//  Template
//
//  Created by liyuchang on 15/12/1.
//  Copyright © 2015年 liyuchang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSTimeInterval(^TransitionDurationCallBack)(id<UIViewControllerContextTransitioning> transitionContext);
typedef void(^AnimateTransitionCallBack)(id<UIViewControllerContextTransitioning> transitionContext);
@interface IOS7ViewControllerAnimateTransitioning : NSObject
<UIViewControllerAnimatedTransitioning,UINavigationControllerDelegate,
UIViewControllerTransitioningDelegate,UIViewControllerInteractiveTransitioning>
@property (nonatomic,copy)TransitionDurationCallBack transitionDurationCallBack;
@property (nonatomic,copy)AnimateTransitionCallBack animateTransitionCallBack;
@property (nonatomic,assign)UIViewController *willShowCtr;

@property (nonatomic, assign, getter = isInteractive) BOOL interactive;
@end
