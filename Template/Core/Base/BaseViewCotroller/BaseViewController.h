//
//  BaseViewController2.h
//  XF9H-HD
//
//  Created by liyuchang on 14-10-22.
//  Copyright (c) 2014年 com.Vacn. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "Define.h"
typedef void (^Call)(void);

@interface BaseViewController : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate,UITextViewDelegate,UIViewControllerTransitioningDelegate,UIScrollViewDelegate>

@property (nonatomic,assign)BOOL removeKeyBoardNotification;
//current conttoller view 尺寸
-(void)removeKeyBoardObservice;
-(CGSize)size;
-(void)viewDidLoadFirstInitView;
-(void)viewDidLoadSecondInitData;
-(void)viewDidLoadThirdDoNetWork;
//statusbar 颜色
-(void)lightstatus;
-(void)darkstatus;
-(void)incomeStatus;
//添加返回箭头，返回事件需要custom写
-(void)addLeftBackItem:(Call)call;
//添加返回箭头，并集成返回事件，自动判断是模态还是nav返回
-(void)addBackItem:(Call)call;
//添加右侧按钮，custom名字，事件
-(void)addRightItemTitle:(NSString *)tite call:(Call)call;

//图片比例高度换算
-(CGFloat)adjustHeightWithWidth:(CGFloat)width height:(CGFloat)height;
//label设置字体颜色等综合方法
-(void)labelStyle:(UILabel *)label textAlignment:(NSTextAlignment)alignment color:(UIColor *)color font:(UIFont *)font;
//label高度
-(CGFloat)mulitLabelHeight:(CGFloat)width str:(NSString *)str font:(UIFont *)font;

////导航栏颜色
//-(void)whiteNav;

-(NSNumber *)nextPage:(RequestObj *)request;
- (NSArray *)findAllSubviews:(UIView *)theView;
-(void)removeAllSubViews;

-(void)addTranstrationNav:(UINavigationController *)nav;
//去除字符串空格 回车
-(NSString *)stringRemoveWhiteSpace:(NSString *)str;

@property (nonatomic,assign)BOOL canShowNoResultCell;

-(void)initTableHeaderLoadingView:(UIScrollView *)tableView;
-(void)initTableFooterLoadingView:(UIScrollView *)tableView;

-(void)refresh;
-(void)append;
@end
