
//
//  BaseViewController2.m
//  XF9H-HD
//
//  Created by liyuchang on 14-10-22.
//  Copyright (c) 2014年 com.Vacn. All rights reserved.
//

#import "BaseViewController.h"
#define KShowStatusBar @"KShowStatusBar"
#define KHiddenStatusBar @"KHiddenStatusBar"
#import "UIKeyboardViewController.h"


@interface BaseViewController ()
{
    UIKeyboardViewController *_keyboard;
    BOOL darkStatus;
    BOOL hiddenStatus;

}
@property (nonatomic,copy)Call call;
@property (nonatomic,copy)Call rightCall;
@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (iOS7||iOS8) {
        self.automaticallyAdjustsScrollViewInsets = YES;
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    [self viewDidLoadFirstInitView];
    [self viewDidLoadSecondInitData];
    [self viewDidLoadThirdDoNetWork];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showStatusBar) name:KShowStatusBar object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenStatusBar) name:KHiddenStatusBar object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(htmlRefresh) name:@"KHtmlRefresh" object:nil];
    
    self.view.backgroundColor = kColor(246, 246, 246);
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    if (darkStatus) {
        return UIStatusBarStyleDefault;
    }else
        return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden
{
    return hiddenStatus;
}

-(void)htmlRefresh
{
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.userInteractionEnabled = NO;
    self.view.window.userInteractionEnabled = NO;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


-(void)removeKeyBoardObservice
{
    _keyboard = nil;
    _removeKeyBoardNotification = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_removeKeyBoardNotification) {
        _keyboard=[[UIKeyboardViewController alloc]initWithControllerDelegate:self];
        _keyboard.spacerY = 30;
    }
    self.view.userInteractionEnabled = YES;
    self.view.window.userInteractionEnabled = YES;
// 下面的代码会影响 UISearchDisplayController 动画效果，点击searchbar时会同时触发endEdit，造成卡顿
//    UIControl *control = [[UIControl alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:control];
//    [control addTarget:self action:@selector(endEdit) forControlEvents:UIControlEventTouchDragInside|UIControlEventTouchUpInside];
//    [self.view sendSubviewToBack:control];
}

-(void)viewDidLoadFirstInitView{NSAssert(NO, @"ERROR:[BaseViewController viewDidLoadFirstInitView] current View controller must overwrite this mathod");}

-(void)viewDidLoadSecondInitData{NSAssert(NO, @"ERROR:[BaseViewController viewDidLoadSecondInitData] current View controller must overwrite this mathod");}

-(void)viewDidLoadThirdDoNetWork{NSAssert(NO, @"ERROR:[BaseViewController viewDidLoadThirdDoNetWork] current View controller must overwrite this mathod");}

-(void)showStatusBar
{
    hiddenStatus = NO;
    if (self.navigationController) {
//        ((BaseNavigationController *)self.navigationController).hiddenStatus = hiddenStatus;
        [self.navigationController setNeedsStatusBarAppearanceUpdate];
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)hiddenStatusBar
{
    hiddenStatus = YES;
    if (self.navigationController) {
//        ((BaseNavigationController *)self.navigationController).hiddenStatus = hiddenStatus;
        [self.navigationController setNeedsStatusBarAppearanceUpdate];
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)addLeftBackItem:(void (^)(void))call
{
    
    self.call = call;
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 50, 50);
//    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
////    [btn setImage:[UIImage imageNamed:@"userinfo_back"] forState:UIControlStateNormal];
//    [btn setTitle:NSLocalizedString(@"返回",@"") forState:UIControlStateNormal];
//    btn.contentMode = UIViewContentModeCenter;
//    ShowBorder(btn, [UIColor redColor]);
//    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回",@"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回",@"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    self.navigationItem.backBarButtonItem = item;
}

-(void)addBackItem:(void (^)(void))call
{
    self.call = call;
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 50, 50);
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
//    [btn addTarget:self action:@selector(back2) forControlEvents:UIControlEventTouchUpInside];
//    [btn setImage:[UIImage imageNamed:@"userinfo_back"] forState:UIControlStateNormal];
//    [btn setTitle:NSLocalizedString(@"返回",@"") forState:UIControlStateNormal];
//    btn.contentMode = UIViewContentModeCenter;
//    ShowBorder(btn, [UIColor redColor]);
//    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回",@"") style:UIBarButtonItemStylePlain target:self action:@selector(back2)];
    self.navigationItem.leftBarButtonItem = left;

//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回",@"") style:UIBarButtonItemStylePlain target:self action:@selector(back2)];
//    self.navigationItem.backBarButtonItem = item;
}




-(void)back
{
    self.navigationItem.leftBarButtonItem.enabled = NO;
    if (self.call) {
        self.call();
    }
}

-(void)back2
{
    if (self.navigationController.viewControllers.count==1) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"########## warn : this view controller in the navigation view controllers list is just one");
        if (self.call) {
            self.call();
        }
        return;
    }
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.call) {
        self.call();
    }
}


-(void)addRightItemTitle:(NSString *)tite call:(Call)call
{
    self.rightCall = call;
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 44, 44);
//    [btn addTarget:self action:@selector(rightDO) forControlEvents:UIControlEventTouchUpInside];
//    [btn setTitle:tite forState:UIControlStateNormal];
//    [btn setTitleColor:RedColor forState:UIControlStateNormal];
//    btn.titleLabel.font = TFont(15);
//    btn.contentMode = UIViewContentModeCenter;
//    ShowBorder(btn, [UIColor redColor]);
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:tite style:UIBarButtonItemStylePlain target:self action:@selector(rightDO)];
    self.navigationItem.rightBarButtonItem = left;
}

-(void)rightDO
{
    if (self.rightCall) {
        self.rightCall();
    }
}


-(void)dealloc
{
    @synchronized(self)
    {
        for (UIView *sub in self.view.subviews) {
            if ([sub isKindOfClass:[UIScrollView class]]) {
                UIScrollView *scroll = (id)sub;
                [scroll removeFooter];
                [scroll removeHeader];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(CGSize)size
{
    return [self.view bounds].size;
}

-(CGFloat)adjustHeightWithWidth:(CGFloat)width height:(CGFloat)height
{
    CGSize size = [self size];
    CGFloat dheight = size.width/((float)width/(float)height);
    return dheight;
}

//通过样稿的长来于当前屏幕的长得出比例，适配样稿里面的元件的比例
-(CGSize) resizewithtemplate:(CGSize)_templatesize :(CGSize)_viewsize
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat scale = size.width/_templatesize.width;
    return CGSizeMake(_viewsize.width*scale, _viewsize.height*scale);
}


-(void)endEdit
{
    [self.view endEditing:YES];
}

-(void)labelStyle:(UILabel *)label textAlignment:(NSTextAlignment)alignment color:(UIColor *)color font:(UIFont *)font
{
    label.textColor = color;
    label.textAlignment = alignment;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
}

-(CGFloat)mulitLabelHeight:(CGFloat)width str:(NSString *)str font:(UIFont *)font
{
    return [str boundingRectWithSize:CGSizeMake(width, 10000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
}


- (NSArray *)findAllSubviews:(UIView *)theView {
    NSArray *results = [theView subviews];
    for (UIView *eachView in [theView subviews]) {
        NSArray *riz = [self findAllSubviews:eachView];
        if (riz) {
            results = [results arrayByAddingObjectsFromArray:riz];
        }
    }
    return results;
}
-(void)removeAllSubViews
{
    NSArray *tempviews = [self findAllSubviews:self.view];
    for (int i=0; i<tempviews.count; i++) {
        UIView *view = [tempviews objectAtIndex:i];
        [view removeFromSuperview];
        view = nil;
    }
}

-(void)addTranstrationNav:(UINavigationController *)nav
{
    nav.transitioningDelegate = self;
    nav.modalPresentationStyle = UIModalPresentationCustom;
}


-(NSString *)stringRemoveWhiteSpace:(NSString *)str
{
    NSString *temp = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
}


-(void)initTableHeaderLoadingView:(UIScrollView *)tableView;
{
    [tableView addHeaderWithTarget:self action:@selector(refresh)];
}
-(void)initTableFooterLoadingView:(UIScrollView *)tableView;
{
    [tableView addFooterWithTarget:self action:@selector(append)];
}

-(void)refresh;
{}
-(void)append;
{}





@end
