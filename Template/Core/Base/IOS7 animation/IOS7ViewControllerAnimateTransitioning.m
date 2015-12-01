//
//  IOS7ViewControllerAnimateTransform.m
//  Template
//
//  Created by liyuchang on 15/12/1.
//  Copyright © 2015年 liyuchang. All rights reserved.
//

#import "IOS7ViewControllerAnimateTransitioning.h"


@interface IOS7ViewControllerAnimateTransitioning ()

@property (nonatomic,readwrite,assign)id <UIViewControllerContextTransitioning> context;
@property (nonatomic,readwrite,retain)UIPanGestureRecognizer *popRecognizer;
@property (nonatomic,readwrite,assign)UIViewController *lastCtr;
@property (nonatomic,readwrite,assign)CGPoint beginTouchPoint;
@property (nonatomic,readwrite,assign)CGPoint endTouchPoint;
@property (nonatomic,readwrite,assign)UIView *fromView;
@property (nonatomic,readwrite,assign)UIView *toView;

@end

/*
 动画控制器 (Animation Controllers) 遵从 UIViewControllerAnimatedTransitioning 协议，并且负责实际执行动画。
 交互控制器 (Interaction Controllers) 通过遵从 UIViewControllerInteractiveTransitioning 协议来控制可交互式的转场。
 转场代理 (Transitioning Delegates) 根据不同的转场类型方便的提供需要的动画控制器和交互控制器。
 转场上下文 (Transitioning Contexts) 定义了转场时需要的元数据，比如在转场过程中所参与的视图控制器和视图的相关属性。 转场上下文对象遵从 UIViewControllerContextTransitioning 协议，并且这是由系统负责生成和提供的。
 转场协调器(Transition Coordinators) 可以在运行转场动画时，并行的运行其他动画。 转场协调器遵从 UIViewControllerTransitionCoordinator 协议
 */
@implementation IOS7ViewControllerAnimateTransitioning
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.transitionDurationCallBack) {
        return self.transitionDurationCallBack(transitionContext);
    }
    return 1;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.animateTransitionCallBack) {
        self.animateTransitionCallBack(transitionContext);
    }else
        NSAssert(NO, @"[ERROR YOU NEED OVERWRITE THIS FUNCRION  animateTransition:]");
}
@end


@interface IOS7ViewControllerAnimateTransitioning (Modal)
@end

@implementation IOS7ViewControllerAnimateTransitioning (Modal)

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator;
{
    return self;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator;
{
    return self;
}


@end


@interface IOS7ViewControllerAnimateTransitioning (Interactive)<UIViewControllerInteractiveTransitioning>

@end

@implementation IOS7ViewControllerAnimateTransitioning (Interactive)

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIPanGestureRecognizer *temprecognizer= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paningGestureReceive:)];
        self.popRecognizer = temprecognizer;
    }
    return self;
}

-(void)setWillShowCtr:(UIViewController *)willShowCtrs
{
    [willShowCtrs.view addGestureRecognizer:self.popRecognizer];
    self.lastCtr = willShowCtrs;
}

-(UIViewController *)willShowCtr
{
    return self.lastCtr;
}

- (CGFloat)completionSpeed;
{
    return 0.2;
}

-(void)startInteractiveTransition:(id)transitionContext {
    self.context = transitionContext;
    UIView *containerView = [transitionContext
                             containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    self.fromView = fromViewController.view;

    self.toView = toViewController.view;
    [self showVisibleShadow];
}

-(void)paningGestureReceive:(UIPanGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:[UIApplication sharedApplication].keyWindow];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self gestureRecognizerStateBegan:touchPoint];
            break;
        case UIGestureRecognizerStateEnded:
            [self gestureRecognizerStateEnd:touchPoint];
            break;
        case UIGestureRecognizerStateCancelled:
            [self gestureRecognizerStateEnd:touchPoint];
            break;
        case UIGestureRecognizerStateChanged:
            [self moveViewWithX:touchPoint.x - self.beginTouchPoint.x];
            break;
        default:
            break;
    }
}

-(void)gestureRecognizerStateBegan:(CGPoint )touchPoint
{
    self.beginTouchPoint = touchPoint;
    self.interactive = YES;
    [self.lastCtr.navigationController popViewControllerAnimated:YES];
}

-(void)showVisibleShadow
{
    self.fromView.layer.shadowOpacity = 0.6f;
    self.fromView.layer.cornerRadius = 4.0f;
    self.fromView.layer.shadowOffset = CGSizeZero;
    self.fromView.layer.shadowRadius = 4.0f;
    CGSize size = [self.context finalFrameForViewController:[self.context viewControllerForKey:UITransitionContextToViewControllerKey]].size;
    self.fromView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0,0,size.width,size.height)].CGPath;
}

-(void)gestureRecognizerStateEnd:(CGPoint )touchPoint
{
    self.interactive = NO;
    if (touchPoint.x-self.beginTouchPoint.x>100) {
        [UIView animateWithDuration:0.2 animations:^{
            self.fromView.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
            self.toView.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width*100.0/self.fromView.frame.size.width -100, 0);
            [self.context finishInteractiveTransition];
        } completion:^(BOOL finished) {
            
            [_context completeTransition:YES];
        }];
        
    }else
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.fromView.transform = CGAffineTransformIdentity;
            self.toView.transform = CGAffineTransformMakeTranslation(0*100.0/self.fromView.frame.size.width -100, 0);;
            [self.context cancelInteractiveTransition];
        }completion:^(BOOL finished) {
            self.toView.transform = CGAffineTransformIdentity;
            
            [_context completeTransition:NO];
        }];
        
    }
}


-(void)moveViewWithX:(CGFloat)x
{
    self.fromView.transform = CGAffineTransformMakeTranslation(x, 0);
    self.toView.transform = CGAffineTransformMakeTranslation(x*100.0/self.fromView.frame.size.width -100, 0);
    [self.context updateInteractiveTransition:x/[UIScreen mainScreen].bounds.size.width];
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation==UINavigationControllerOperationPop) {
        return self.interactive?self:nil;
    }
    return nil;
}


- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    return self.interactive?self:nil;;
}



@end