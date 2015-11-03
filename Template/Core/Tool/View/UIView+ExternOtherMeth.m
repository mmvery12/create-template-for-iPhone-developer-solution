//
//  UIView+ExternOtherMeth.m
//  HuLuWa
//
//  Created by liyuchang on 15/6/3.
//  Copyright (c) 2015年 liyuchang. All rights reserved.
//

#import "UIView+ExternOtherMeth.h"

@implementation UIView (ExternOtherMeth)
-(void)setOneLabelHeight:(NSTextAlignment)aligment font:(UIFont *)font color:(UIColor*)color
{
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *temp = (id)self;
        temp.textAlignment = aligment;
        temp.font = font;
        temp.textColor = color;
        CGFloat height = [@"123" boundingRectWithSize:CGSizeMake(self.frame.size.width, 10000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
        CGRect frame = self.frame;
        frame.size.height = height;
        self.frame = frame;
    }else
        NSLog(@"##### self is not response to OneLineLabel  uilabel class");
}

-(void)setMulLabelHeight:(NSString *)content aligment:(NSTextAlignment)aligment font:(UIFont *)font color:(UIColor*)color
{
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *temp = (id)self;
        temp.textAlignment = aligment;
        temp.font = font;
        temp.textColor = color;
        CGFloat height = [content boundingRectWithSize:CGSizeMake(self.frame.size.width, 10000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
        CGRect frame = self.frame;
        frame.size.height = height;
        self.frame = frame;
        temp.text = content;
        temp.numberOfLines = 0;
    }else
        NSLog(@"##### self is not response to MultiLineLabel  uilabel class");
}

+(CGSize)oneLineTextSize:(NSString *)string font:(UIFont *)font;
{
   return [string boundingRectWithSize:CGSizeMake(10000000, 10000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}
@end
