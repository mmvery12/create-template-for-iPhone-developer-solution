//
//  SystemAssisent.h
//  XFGJ
//
//  Created by liyuchang on 15-1-28.
//  Copyright (c) 2015年 com.Vacn. All rights reserved.
//

#ifndef XFGJ_SystemAssisent_h
#define XFGJ_SystemAssisent_h
// 1.判断是否为iPhone5的宏
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)

#define iPhone6 ([UIScreen mainScreen].bounds.size.height == 667)
#define iPhone6Plus ([UIScreen mainScreen].bounds.size.height == 736)


#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)

#define def_addHeight [[UIScreen mainScreen] bounds].size.height-480

#define nav_def_addHeight [[UIScreen mainScreen] bounds].size.height-480+416
#define navbar_def_addHeight [[UIScreen mainScreen] bounds].size.height-480+416-49
#define bar_def_addHeight [[UIScreen mainScreen] bounds].size.height-480+431

#define isIphone6s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIphone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIphone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

#define DEC_WEAKSELF __typeof(&*self) __weak weakSelf = self
#define DEC_WEAKOBJECT(_obj) __typeof(&*_obj) __weak weak##_obj = _obj

#ifdef CUSTOM_DEUBG
#define XXLog(...) printf([[NSString stringWithFormat:@"LOG : %@ \r",[NSString stringWithFormat:__VA_ARGS__]] UTF8String],nil)
#else
#define XXLog(...)
#endif

#ifndef __ARC__
#define XXRelease(s) [s release]
#define XXDealloc(s) XXRelease(s);s = nil
#define XXNil(s)     s = nil
#else
#define XXRelease(s)
#define XXDealloc(s)
#define XXNil(s)
#endif

#if __clang__
#define XNSFormatString(...) [NSString stringWithFormat:__VA_ARGS__]
#define XNSArray(...)   [NSArray arrayWithObjects:__VA_ARGS__,nil]
#define XMNSArray       [NSMutableArray array]

#define SetImage(_image,_imageName) _image.image=[UIImage imageNamed:_imageName]
#define SetImageFromeFile(_image,_imageName) _image.image = [UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",_imageName]]]
#endif
#endif

#define ClearBackground(_view) _view.backgroundColor = [UIColor clearColor]
#define WhiteBackground(_view) _view.backgroundColor = [UIColor whiteColor]
#define ColorBackground(_view,_color) _view.background = _color
// 获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define RedColor [PSColorToRGB getColor:@"58bdc0"]

//[PSColorToRGB getColor:@"fb436d"]
#define LightColor  [PSColorToRGB getColor:@"666666"]
#define LLightColor  [[PSColorToRGB getColor:@"666666"] colorWithAlphaComponent:0.7]
#define LLLightColor  [[PSColorToRGB getColor:@"666666"] colorWithAlphaComponent:0.35]
#define F7F5F5Color [PSColorToRGB getColor:@"f7f5f5"]
#define TFont(_x) [UIFont systemFontOfSize:_x]
//
#define BlackColor [UIColor blackColor]
#define ShowBorder(view,color) [view showBorder:color]
#define LineColor [UIColor colorWithRed:234/255.0 green:235/255.0 blue:236/255.0 alpha:1]
#define ShowRedBorder(view) [view showBorder:[UIColor redColor]]
#define ShowColorBorder(view,color) [view showBorder:color]
@interface UIView (Border)
-(void)showBorder:(UIColor *)color;
@end

@implementation UIView (Border)

-(void)showBorder:(UIColor *)color
{

#ifdef Show_border
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 1.0f;
#endif
}
@end


//#define XNSArray(...)	\
//NSArray *getArr(id first,...) \
//{ \
//va_list var_arg; \
//id temp; \
//NSMutableArray *marr = [NSMutableArray array]; \
//va_start(var_arg,first); \
//while (1) { \
//temp = var_arg(var_arg,NSObject *); \
//if (!temp) { \
//break; \
//} \
//[marr addObject:temp]; \
//} \
//va_end(var_arg); \
//return marr; \
//} \

