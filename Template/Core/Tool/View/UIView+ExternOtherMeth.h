//
//  UIView+ExternOtherMeth.h
//  HuLuWa
//
//  Created by liyuchang on 15/6/3.
//  Copyright (c) 2015年 liyuchang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ExternOtherMeth)
-(void)setOneLabelHeight:(NSTextAlignment)aligment font:(UIFont *)font color:(UIColor*)color;
-(void)setMulLabelHeight:(NSString *)content aligment:(NSTextAlignment)aligment font:(UIFont *)font color:(UIColor*)color;
+(CGSize)oneLineTextSize:(NSString *)string font:(UIFont *)fone;
@end
