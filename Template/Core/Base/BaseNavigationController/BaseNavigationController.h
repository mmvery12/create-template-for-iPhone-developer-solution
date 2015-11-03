//
//  BaseNavigationController.h
//  XFGJ
//
//  Created by liyuchang on 14-8-14.
//  Copyright (c) 2014年 com.Vacn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//gesture --begin
#define movespace 257
@class BaseNavigationController;
typedef enum
{
    LeftDirection = 1,
    RightDirection = 2,
    NoneDirection
}Direction;
@protocol BaseNavDelegate <NSObject>
@optional
-(BOOL)canPop;
-(void)basenavDidPop:(BaseNavigationController *)baseNav;
@end
//gesture --end
@interface BaseNavigationController : UINavigationController<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    BOOL _isAnimate;
    BOOL _canPop;
    
    //gesture --begin
    NSMutableArray *__snapshotArray;
    UIView *__snapshotholderview;
    UIView *__centerCoverView;
    
    NSMutableArray *__snapshotBarArray;
    UIView *__lastBarShotView;
    UIImageView *__lastScreenShotView;
    UIView *barBackgroundView;
    UIView *_barBackIndicatorView;
    CGPoint __beginTouchPoint;
    
    BOOL __isShowingLeft;
    BOOL __isShowingRight;
    BOOL __isPop;
    BOOL __isAnimating;
    
    
    UITapGestureRecognizer *__centerTap;
    
    BOOL __canChangeBarStatuts;
    BOOL __isShowShadow;
    Class __classIsa;
    CGFloat __lastedOriginX;
    //gesture --end
}
+(BaseNavigationController *)baseNavControllerRootViewController:(UIViewController *)controller withTin:(UIColor *)tincolor;/**@brief 构造方法，传入tincolor，通过tincolor构造nav*/
+(BaseNavigationController *)baseNavControllerRootViewController:(UIViewController *)controller withImage:(UIImage *)tinImage;/**@brief 构造方法，传入image，通过image构造nav*/

//gesture --begin
@property (nonatomic,assign)id<BaseNavDelegate> basedelegate;
@property (nonatomic,assign) BOOL canDragBack;//def NO
@property (nonatomic,assign) BOOL canDragLeft;
@property (nonatomic,assign) BOOL canDragRight;
@property (nonatomic,assign)UIViewController *lController;
@property (nonatomic,assign)UIViewController *rController;
@property (nonatomic,readonly)NSUInteger maxPan;/** @brief 滑动停止时max位移*/

@property (nonatomic,assign)UIStatusBarStyle statusBarstyle;
@property (nonatomic,assign)BOOL hiddenStatus;
-(void)showCController:(BOOL)animate;
-(void)showLController:(BOOL)animate;
-(void)showRController:(BOOL)animate;
-(void)hiddenLController:(BOOL)animate;
-(void)hiddenRController:(BOOL)animate;
//gesture --end
@end

