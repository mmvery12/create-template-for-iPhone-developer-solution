//
//  BaseNavigationController.m
//  XFGJ
//
//  Created by liyuchang on 14-8-14.
//  Copyright (c) 2014年 com.Vacn. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseNavigationController+Rotation.h"
#import <objc/runtime.h>
#import "UIView+Snapshot.h"
#import <objc/message.h>

#define ANIMATE_TIME 0.25

#ifndef iOS7
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
#endif

#define dragespace 30
#define KEY__WINDOW [[UIApplication sharedApplication] keyWindow]

@interface BaseNavigationController ()
@property (nonatomic,copy)UIColor *color;
@property (nonatomic,copy)UIImage *image;
//gesture --begin
@property (nonatomic,strong)UIViewController *leftCTR;
@property (nonatomic,strong)UIViewController *rightCTR;
//gesture --end
@end



@implementation BaseNavigationController
//gesture --begin
@synthesize basedelegate = __basedelegate;
@synthesize canDragBack = __canDragBack;
@synthesize leftCTR=__leftCTR;
@synthesize rightCTR=__rightCTR;
@synthesize maxPan = __maxPan;
@synthesize canDragLeft = _canDragLeft;
@synthesize canDragRight = _canDragRight;
//gesture --end

/**
 * @brief  构造方法，传入tincolor，通过tincolor构造nav
 * @author 李煜昌
 * @date   2014-9-9
 * @version 1.0
 * @param  controller 根controller
 * @param  tincolor 导航条背景色
 * @return BaseNavigationController *指针
 */
+(BaseNavigationController *)baseNavControllerRootViewController:(UIViewController *)controller withTin:(UIColor *)tincolor
{
    BaseNavigationController *base = [[BaseNavigationController alloc] init];
    base.color = tincolor;
    base.viewControllers = [NSArray arrayWithObject:controller];
    return base;
}

/**
 * @brief  构造方法，传入tincolor，通过image构造nav
 * @author 李煜昌
 * @date   2014-9-9
 * @version 1.0
 * @param  controller 根controller
 * @param  tinImage 导航条图像
 * @return BaseNavigationController *指针
 */
+(BaseNavigationController *)baseNavControllerRootViewController:(UIViewController *)controller withImage:(UIImage *)tinImage
{
    BaseNavigationController *base = [[BaseNavigationController alloc] init];
    base.image = tinImage;
    base.viewControllers = [NSArray arrayWithObject:controller];
    return base;
}



/**
 * @brief  viewDidLoad初始化方法
 * @author 李煜昌
 * @date   2014-9-9
 * @version 1.0
 */
- (void)viewDidLoad
{
//    self.delegate = self;
    [super viewDidLoad];
    [self navbarConfig];
//    [self gestureConfig];
}

-(void)navbarConfig
{
    [[UINavigationBar appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:20],NSFontAttributeName,nil]];

    if (iOS7||iOS8) {
    
        if (self.color) {
            UIGraphicsBeginImageContextWithOptions(CGSizeMake([UIScreen mainScreen].bounds.size.width, 64), NO, [UIScreen mainScreen].scale);
            [self.color set];
            UIRectFill(CGRectMake(0, 0, self.navigationBar.frame.size.width, 64));
            UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
            [self.navigationBar setBackgroundImage:pressedColorImg forBarMetrics:UIBarMetricsDefault];
            [self.navigationBar setShadowImage:[UIImage new]];

        }else
            if (self.image) {
                [self.navigationBar setBackgroundImage:self.image forBarMetrics:UIBarMetricsDefault];
                [self.navigationBar setShadowImage:[UIImage new]];
            }
    }else
    {
        UIGraphicsBeginImageContextWithOptions(self.navigationBar.frame.size, NO, [UIScreen mainScreen].scale);
        if (self.color) {
            [self.color set];
        }else
            if (self.image) {
                [[UIColor colorWithPatternImage:self.image] set];
            }
        UIRectFill(CGRectMake(0, 0, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height));
        UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self.navigationBar setBackgroundImage:pressedColorImg forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationBar.translucent=YES;
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    @synchronized(self)
    {
        //gesture --begin
        [__snapshotArray removeLastObject];
        [__snapshotBarArray removeLastObject];
        
        [__lastScreenShotView removeFromSuperview];
        [__lastBarShotView removeFromSuperview];
        
        __snapshotholderview.hidden=YES;
        __lastBarShotView = nil;
        __lastScreenShotView = nil;
        if (__classIsa==object_getClass(__basedelegate) && [__basedelegate respondsToSelector:@selector(basenavDidPop:)]) {
            [__basedelegate basenavDidPop:self];
        }
        //gesture --end
        
        if (_isAnimate==NO||_canPop) {
            _isAnimate = YES;
            _canPop = NO;
            self.view.window.userInteractionEnabled = NO;
            [[NSNotificationCenter defaultCenter] removeObserver:[self.viewControllers lastObject]];
            [self performSelector:@selector(isAnimate) withObject:nil afterDelay:ANIMATE_TIME];
            return [super popViewControllerAnimated:animated];
        }
        return nil;
    }
}

-(NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    @synchronized(self)
    {
        if (_isAnimate==NO) {
            _isAnimate = YES;
            if ([self.viewControllers count]!=1) {
                for (int i=1; i<[self.viewControllers count]; i++) {
                    [[NSNotificationCenter defaultCenter] removeObserver:self.viewControllers[i]];
                }
                self.view.window.userInteractionEnabled = NO;
            }
            [self performSelector:@selector(isAnimate) withObject:nil afterDelay:ANIMATE_TIME];
            return [super popToRootViewControllerAnimated:animated];
        }
        return nil;
    }
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    @synchronized(self)
    {
        //gesture --begin
        {
            [__snapshotArray addObject:[self.visibleViewController.view snapshot]];
        }
        [__snapshotBarArray addObject:[self barSnapshot]];
        __centerCoverView.hidden = YES;
        //gesture --end
        
        if (_isAnimate==NO) {
            _isAnimate = YES;
            self.view.window.userInteractionEnabled = NO;
            NSArray *temp = self.viewControllers;
            for (int i=1; i<temp.count&&temp.count>=10; i++) {
                _canPop = YES;
                UIViewController *ctr = (id)temp[i];
                [ctr.navigationController popViewControllerAnimated:NO];
                _canPop = NO;
            }
            [self performSelector:@selector(isAnimate) withObject:nil afterDelay:ANIMATE_TIME];
            [super pushViewController:viewController animated:animated];
        }
    }
}

-(void)isAnimate
{
    _isAnimate = NO;
    self.view.window.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.view.window.userInteractionEnabled = NO;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.view.window.userInteractionEnabled = YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


/**
 * @brief  didReceiveMemoryWarning方法，收到内存警告触发方法
 * @author 李煜昌
 * @date   2014-9-9
 * @version 1.0
 */
- (void)didReceiveMemoryWarning
{
    return;
    NSArray *temp = self.viewControllers;
    for (int i=1; i<(temp.count-1); i++) {
        _canPop = YES;
        UIViewController *ctr = (id)temp[i];
        [ctr.navigationController popViewControllerAnimated:NO];
        _canPop = NO;
    }
    [super didReceiveMemoryWarning];
}



#pragma mark Geuture －－
-(void)setCanDragLeft:(BOOL)canDragLeft
{
    if (self.lController && canDragLeft) {
        _canDragLeft = YES;
    }else
        _canDragLeft = NO;
}

-(void)setCanDragRight:(BOOL)canDragRight
{
    if (self.rController && canDragRight) {
        _canDragRight = YES;
    }else
        _canDragRight = NO;
}
//gesture --begin
-(UIViewController *)RController
{
    return self.rightCTR;
}
-(void)setRightCTR:(UIViewController *)rightCTR
{
    self.rightCTR = rightCTR;
}
-(UIViewController *)lController
{
    return self.leftCTR;
}
-(void)setLeftCTR:(UIViewController *)leftCTR
{
    self.leftCTR = leftCTR;
}
-(void)setBasedelegate:(id<BaseNavDelegate>)basedelegate
{
    __basedelegate = basedelegate;
    __classIsa = object_getClass(__basedelegate);
}
-(id)initWithRootViewController:(id)rootViewController lController:(UIViewController *)leftCtr rController:(UIViewController *)rightCtr;
{
    self.leftCTR = leftCtr;
    if (self.leftCTR) {
        _canDragLeft = YES;
    }
    
    self.rightCTR = rightCtr;
    if (self.rightCTR) {
        _canDragRight = YES;
    }
    
    __canDragBack = YES;
    return [super initWithRootViewController:rootViewController];
}

-(void)gestureConfig
{
    __canDragBack = YES;
    {
        UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(paningGestureReceive:)];
//        popRecognizer.edges = UIRectEdgeAll;
        [self.view addGestureRecognizer:popRecognizer];
        
        if (iOS7) self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    {
        if (self.leftCTR && _canDragLeft) {
            _canDragLeft = YES;
        }else
            _canDragLeft = NO;
        
        if (self.rightCTR && _canDragRight) {
            _canDragRight = YES;
        }else
            _canDragRight = NO;
        
        __snapshotholderview = [[UIView alloc]init];
        __isShowShadow = NO;
        __canChangeBarStatuts = YES;
        __maxPan = movespace;
        __snapshotArray = [[NSMutableArray alloc] init];
        __snapshotBarArray = [[NSMutableArray alloc] init];
        __centerCoverView = [[UIView alloc] initWithFrame:self.view.bounds];
        __centerCoverView.backgroundColor = [UIColor clearColor];
        __centerCoverView.hidden = YES;
        [self.view addSubview:__centerCoverView];
    }
    {
        __centerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShowRoot:)];
        __centerTap.numberOfTapsRequired = 1;
        __centerTap.numberOfTouchesRequired = 1;
    }
    {
//        if (iOS7) [self setNeedsStatusBarAppearanceUpdate];
    }
}

-(void)tapShowRoot:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded && tap.numberOfTapsRequired ==1 &&tap.numberOfTouchesRequired ==1) {
        [self showCController:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenLView:YES];
    [self hiddenRView:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (__leftCTR&&![KEY__WINDOW.subviews containsObject:__leftCTR.view]) {
        [KEY__WINDOW insertSubview:__leftCTR.view atIndex:0];
        [self hiddenLView:YES];
    }
    if (__rightCTR&&![KEY__WINDOW.subviews containsObject:__rightCTR.view]) {
        [KEY__WINDOW insertSubview:__rightCTR.view atIndex:0];
        [self hiddenRView:YES];
    }
    {
        self.view.layer.shadowOpacity = 0.f;
        self.view.layer.cornerRadius = 4.0f;
        self.view.layer.shadowOffset = CGSizeZero;
        self.view.layer.shadowRadius = 4.0f;
        self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)].CGPath;
    }
}
- (UIView *)barBackgroundView
{
    if (barBackgroundView) return barBackgroundView;
    for (UIView *subview in self.navigationBar.subviews) {
        if (!subview.hidden && subview.frame.size.height >= self.navigationBar.frame.size.height
            && subview.frame.size.width >= self.navigationBar.frame.size.width) {
            barBackgroundView = subview;
            break;
        }
    }
    return barBackgroundView;
}

- (UIImage *)barSnapshot
{
    self.barBackgroundView.hidden = YES;
    UIImage *viewImage = [self.navigationBar snapshot];
    self.barBackgroundView.hidden = NO;
    return viewImage;
}


-(void)addCover
{
    if ([__centerCoverView.gestureRecognizers containsObject:__centerTap]||__centerCoverView.hidden == NO) {
        return;
    }
    __centerCoverView.hidden = NO;
    [__centerCoverView addGestureRecognizer:__centerTap];
}
-(void)removeCover
{
    [self showShadow:NO];
    __centerCoverView.hidden = YES;
    [__centerCoverView removeGestureRecognizer:__centerTap];
    [self hiddenLView:YES];
    [self hiddenRView:YES];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint touchPoint = [gestureRecognizer locationInView:KEY__WINDOW];
    if (touchPoint.x>50) {
        return NO;
    }
    return YES;
}

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    CGPoint touchPoint = [recoginzer locationInView:KEY__WINDOW];
    __isPop = self.viewControllers.count == 1?NO:YES;
    
    if (__isPop
        && [self.visibleViewController respondsToSelector:@selector(canPop)])
    {
        /*
         depdence
         Build Setting--> Apple LLVM 6.0 - Preprocessing--> Enable Strict Checking of objc_msgSend Calls  改为 NO
         */
        if (!objc_msgSend(self.visibleViewController, @selector(canPop))) {
            return;
        }
    }
    
    switch (recoginzer.state) {
        case UIGestureRecognizerStateBegan:
            [self gestureRecognizerStateBegan:touchPoint];
            break;
        case UIGestureRecognizerStateEnded:
            [self gestureRecognizerStateEnd:touchPoint];
            break;
        case UIGestureRecognizerStateCancelled:
            [self gestureRecognizerStateCancelled:touchPoint];
            break;
        case UIGestureRecognizerStateChanged:
            [self moveViewWithX:touchPoint.x - __beginTouchPoint.x+__lastedOriginX];
            break;
        default:
            break;
    }
}

-(void)gestureRecognizerStateBegan:(CGPoint )touchPoint
{
    __beginTouchPoint = touchPoint;
    if (__isPop && __canDragBack) {
        
//        UIViewController * temp1=[self.viewControllers lastObject];
//        UIViewController *temp2 = [self.viewControllers objectAtIndex:self.viewControllers.count-2];
//        BOOL x1 = temp1.navigationController.navigationBarHidden;
//        BOOL x2 = temp2.navigationController.navigationBarHidden;
//        if ( !x1 && !x2)
//        {
//            CGRect frame = self.topViewController.view.frame;
//            __snapshotholderview.frame = frame;
//            if (__lastScreenShotView) [__lastScreenShotView removeFromSuperview];
//            __lastScreenShotView = [[UIImageView alloc]initWithImage:[__snapshotArray lastObject]];
//            [__snapshotholderview addSubview:__lastScreenShotView];
//            __snapshotholderview.hidden = NO;
//            [self showVisibleShadow];
//            [self.visibleViewController.view.superview insertSubview:__snapshotholderview belowSubview:self.visibleViewController.view];
//            if (__lastBarShotView) [__lastBarShotView removeFromSuperview];
//            __lastBarShotView = [[UIImageView alloc] initWithImage:[__snapshotBarArray lastObject]];
//            __lastBarShotView.alpha = 0;
//            [self.navigationBar addSubview:__lastBarShotView];
//        }
//        else
        {
            CGRect frame = self.view.frame;
            __snapshotholderview.frame = frame;
            if (__lastScreenShotView) [__lastScreenShotView removeFromSuperview];
            __lastScreenShotView = [[UIImageView alloc]initWithImage:[__snapshotArray lastObject]];
            [__snapshotholderview addSubview:__lastScreenShotView];
            __snapshotholderview.hidden = NO;
            [self showVisibleShadow];
            [self.view.superview insertSubview:__snapshotholderview belowSubview:self.view];
        }
    }
}

-(void)showVisibleShadow
{
//    self.visibleViewController.view.layer.shadowOpacity = 0.6f;
//    self.visibleViewController.view.layer.cornerRadius = 4.0f;
//    self.visibleViewController.view.layer.shadowOffset = CGSizeZero;
//    self.visibleViewController.view.layer.shadowRadius = 4.0f;
//    self.visibleViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    self.view.layer.shadowOpacity = 0.6f;
    self.view.layer.cornerRadius = 4.0f;
    self.view.layer.shadowOffset = CGSizeZero;
    self.view.layer.shadowRadius = 4.0f;
    self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;


}



-(void)gestureRecognizerStateEnd:(CGPoint )touchPoint
{
    if (__isPop) {
        if (__canDragBack) {
            if ((touchPoint.x - __beginTouchPoint.x) > dragespace) {
                [self panPop];
            }else
                [self panRest];
        }
    }else
    {
        Direction direction;
        if (abs(touchPoint.x - __beginTouchPoint.x) > dragespace) {
            if ((touchPoint.x-__beginTouchPoint.x) > dragespace) {
                direction = LeftDirection;
            }else
                if ((touchPoint.x-__beginTouchPoint.x) < -dragespace) {
                    direction = RightDirection;
                }else
                    direction = NoneDirection;
        }else
        {
            direction = NoneDirection;
        }
        switch (direction) {
            case NoneDirection:
                [self panNoneDirection:YES];
                break;
            case LeftDirection:
                [self panLeftDirection:YES];
                break;
            case RightDirection:
                [self panRightDirection:YES];
                break;
            default:
                break;
        }
    }
}

-(void)gestureRecognizerStateCancelled:(CGPoint )touchPoint
{
    [UIView animateWithDuration:0.15 animations:^{
        [self moveViewWithX:0];
        self.view.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        [self resetLastedOriginX];
        [self coverReject];
        self.view.userInteractionEnabled = YES;
    }];
}

-(void)panLeftDirection:(BOOL)animate
{
    [UIView animateWithDuration:animate?0.15:0 animations:^{
        [self moveViewWithX:__isShowingRight?0: movespace];
        self.view.userInteractionEnabled = NO;
    } completion:^(BOOL finish){
        [self hiddenRView:YES];
        [self resetLastedOriginX];
        [self coverReject];
        self.view.userInteractionEnabled = YES;
    }];
}

-(void)panRightDirection:(BOOL)animate
{
    [UIView animateWithDuration:animate?0.15:0 animations:^{
        [self moveViewWithX:__isShowingLeft?0: -movespace];
        self.view.userInteractionEnabled = NO;
    } completion:^(BOOL finish){
        [self hiddenLView:YES];
        [self resetLastedOriginX];
        [self coverReject];
        self.view.userInteractionEnabled = YES;
    }];
}

-(void)panNoneDirection:(BOOL)animate
{
    [UIView animateWithDuration:animate?0.15:0 animations:^{
        if (__isShowingLeft || __isShowingRight) [self moveViewWithX:__lastedOriginX];
        else [self moveViewWithX:0];
        self.view.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        [self coverReject];
        [self resetLastedOriginX];
        self.view.userInteractionEnabled = YES;
    }];
}

-(void)coverReject
{
    if (!__isShowingRight&&!__isShowingLeft) [self removeCover];
    else  [self addCover];
}

-(void)resetLastedOriginX
{
    __lastedOriginX = self.view.frame.origin.x;
}

-(void)panRest
{
    [UIView animateWithDuration:0.15 animations:^{
        [self moveViewWithX:0];
        self.view.userInteractionEnabled = NO;
    } completion:^(BOOL finish){
        [self resetLastedOriginX];
        self.view.userInteractionEnabled = YES;
    }];
}

-(void)panPop
{
    [UIView animateWithDuration:0.15 animations:^{
        [self moveViewWithX:self.view.frame.size.width];
        self.view.userInteractionEnabled = NO;
    } completion:^(BOOL finish){
        [self resetOriginFrame];
        [self resetLastedOriginX];
        _canPop = YES;
        [self popViewControllerAnimated:NO];
        self.view.userInteractionEnabled = YES;
    }];
}

-(void)resetOriginFrame
{
    CGRect rect = self.view.frame;
    rect.origin.x = 0;
    self.view.frame = rect;
}

- (void)moveViewWithX:(float)x
{
    if (__isAnimating) {
        return;
    }
    if (!__isPop && (_canDragLeft||_canDragRight)) {
        if (x>0 || x<0) {
            [self showShadow:YES];
            __canChangeBarStatuts = NO;
//            if (iOS7) [self setNeedsStatusBarAppearanceUpdate];
        }
        if (x==0) {
            __canChangeBarStatuts = YES;
//            if (iOS7) [self setNeedsStatusBarAppearanceUpdate];
        }
        if ((!_canDragLeft && x>0) || (!_canDragRight && x<0)) x = 0;
        if (_canDragLeft && x>0) {
            [self hiddenLView:NO];
            [self hiddenRView:YES];
        }
        if (_canDragRight && x<0) {
            [self hiddenRView:NO];
            [self hiddenLView:YES];
        }
        if ((_canDragRight || _canDragLeft) && x==0) {
            [self hiddenRView:YES];
            [self hiddenLView:YES];
        }
        CGFloat scaleX = (0.175/self.view.frame.size.width)*abs(x);
        CGAffineTransform transS;
        CGAffineTransform transT = CGAffineTransformMakeTranslation(x, 0);
        CGAffineTransform conT;
        transS = CGAffineTransformMakeScale(1, 1-scaleX);
        conT = CGAffineTransformConcat(transS,transT);
        [self.view setTransform:conT];
    }
    else
        if (__isPop && __canDragBack)
        {
            if (x<0) x=0;
//            UIViewController * temp1=[self.viewControllers lastObject];
//            UIViewController *temp2 = [self.viewControllers objectAtIndex:self.viewControllers.count-2];
//            if (temp1.navigationController.navigationBarHidden != YES && temp2.navigationController.navigationBarHidden!=YES)
//            {
//                CGRect frame = self.visibleViewController.view.frame;
//                frame.origin.x = x;
//                self.visibleViewController.view.frame = frame;
//                
//                frame = __lastScreenShotView.frame;
//                frame.origin.x =  x*100.0/self.view.frame.size.width -100;
//                __lastScreenShotView.frame = frame;
//                
//                CGFloat k = x/frame.size.width;
//                if (k>=0.3) {
//                    __lastBarShotView.alpha = 2*(k-0.3);
//                }
//                [self barTransitionWithAlpha:1-k*2];
//            }
//            else
            {
                CGRect frame = self.view.frame;
                frame.origin.x = x;
                self.view.frame = frame;
                frame = __lastScreenShotView.frame;
                frame.origin.x =  x*100.0/self.view.frame.size.width -100;
                __lastScreenShotView.frame = frame;
                
            }
    
            
        }
}
- (UIView *)barBackIndicatorView
{
    if (!_barBackIndicatorView) {
        for (UIView *subview in self.navigationBar.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")]) {
                _barBackIndicatorView = subview;
                break;
            }
        }
    }
    return _barBackIndicatorView;
}

- (void)barTransitionWithAlpha:(CGFloat)alpha
{
    UINavigationItem *topItem = self.navigationBar.topItem;
    
    UIView *topItemTitleView = topItem.titleView;
    
    if (!topItemTitleView) { // 找titleview
        UIView *defaultTitleView = nil;
        @try {
            defaultTitleView = [topItem valueForKey:@"_defaultTitleView"];
        }
        @catch (NSException *exception) {
            defaultTitleView = nil;
        }
        topItemTitleView = defaultTitleView;
    }
    
    topItemTitleView.alpha = alpha;
    
    if (!topItem.leftBarButtonItems.count) { // 找后退按钮Item
        UINavigationItem *backItem = self.navigationBar.backItem;
        UIView *backItemBackButtonView = nil;
        
        @try {
            backItemBackButtonView = [backItem valueForKey:@"_backButtonView"];
        }
        @catch (NSException *exception) {
            backItemBackButtonView = nil;
        }
        backItemBackButtonView.alpha = alpha;
        self.barBackIndicatorView.alpha = alpha;
    }
    
    [topItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem *barButtonItem, NSUInteger idx, BOOL *stop) {
        barButtonItem.customView.alpha = alpha;
    }];
    
    [topItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem *barButtonItem, NSUInteger idx, BOOL *stop) {
        barButtonItem.customView.alpha = alpha;
    }];
}
- (void)showShadow:(BOOL)val {
    if (__isShowShadow&&!val) {
        self.view.layer.shadowOpacity = 0.0f;
        __isShowShadow = val;
    }else
    {
        if (__isShowShadow) {
            return;
        }else if(val)
        {
            self.view.layer.shadowOpacity = 0.7f;
            __isShowShadow = val;
        }
    }
}

-(void)showCController:(BOOL)animate
{
    [UIView animateWithDuration:animate?0.2:0 animations:^{
        [self moveViewWithX:0];
    } completion:^(BOOL finish){
        [self removeCover];
        [self resetLastedOriginX];
    }];
}
-(void)showLController:(BOOL)animate
{
    [self panLeftDirection:animate];
}

-(void)showRController:(BOOL)animate
{
    [self panRightDirection:animate];
}

-(void)hiddenLView:(BOOL)hidden
{
    if (__leftCTR)
    {
        __isShowingLeft = !hidden;
        __leftCTR.view.alpha  = !hidden;
        __leftCTR.view.userInteractionEnabled =!hidden;
    }
}

-(void)hiddenRView:(BOOL)hidden
{
    if (__rightCTR)
    {
        __isShowingRight = !hidden;
        __rightCTR.view.alpha = !hidden;
        __rightCTR.view.userInteractionEnabled = !hidden;
    }
}
-(void)hiddenLController:(BOOL)animate
{
    NSAssert(__isShowingRight, @"Error left view controller is not showing");
    [self panRightDirection:animate];
}
-(void)hiddenRController:(BOOL)animate
{
    NSAssert(__isShowingRight, @"Error left view controller is not showing");
    [self panLeftDirection:animate];
}
//gesture --end

#pragma mark -- status bar style /status
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return _statusBarstyle;
}

-(BOOL)prefersStatusBarHidden
{
    return _hiddenStatus;
}

@end

