//
//  TextView.m
//  HuLuWa
//
//  Created by liyuchang on 15/5/25.
//  Copyright (c) 2015年 liyuchang. All rights reserved.
//

#import "TextView.h"

@interface TextView ()
{
    UILabel *label;
    NSInteger count;
    UILabel *deflabel;
    UITextView *textView;
}
@end

@implementation TextView
- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font count:(NSInteger)counts def:(NSString *)str
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat  height = [@"123/123" boundingRectWithSize:CGSizeMake(frame.size.width, 10000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
        
        textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        textView.delegate = self;
        textView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        textView.contentInset = UIEdgeInsetsZero;
        [self addSubview:textView];
        self.font = font;
//        self.textColor = LightColor;
        textView.textColor = [LightColor colorWithAlphaComponent:0.6];
        
        count = counts;
        label = [[UILabel alloc] initWithFrame:CGRectMake(5, textView.frame.origin.y+textView.frame.size.height+5, frame.size.width, height)];
        label.textColor = [UIColor blackColor];
//        [self addSubview:label];
        label.font = TFont(13);
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = LLightColor;
        
        height = [str  boundingRectWithSize:CGSizeMake(frame.size.width, 10000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
        deflabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, textView.frame.size.width-10, height)];
        deflabel.text = str;
        deflabel.font = font;
        [self addSubview:deflabel];
        deflabel.textColor = [LightColor colorWithAlphaComponent:0.3];
        deflabel.textAlignment = NSTextAlignmentLeft;
        deflabel.numberOfLines = 2;
    }
    return self;
}

-(void)setReturnType:(UIReturnKeyType)returnType
{
    textView.returnKeyType = returnType;
}


-(NSString *)text
{
    return textView.text;
}

-(void)setText:(NSString *)text
{
    textView.text = text;
    if (text.length>0) {
        deflabel.hidden = YES;
    }else
        deflabel.hidden = NO;
    
}


-(void)setFont:(UIFont *)font
{
    textView.font = font;
}

-(void)setTextColor:(UIColor *)textColor
{
//    textView.textColor = textColor;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    label.hidden = NO;
    deflabel.hidden = YES;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
}
- (void)textViewDidEndEditing:(UITextView *)textViews
{
    label.hidden = YES;
    if (textViews.text.length==0) {
        deflabel.hidden = NO;        
    }else
        deflabel.hidden = YES;

}

-(void)textViewDidChange:(UITextView *)textViews
{
    label.text = [NSString stringWithFormat:@"%ld/%ld",textViews.text.length,count];
    if (_textViewDelegate && [_textViewDelegate respondsToSelector:@selector(textViewDidChanges:)]) {
        [_textViewDelegate textViewDidChanges:self];
    }
}


- (BOOL)textView:(UITextView *)textViews shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textViews.text.length>=count) {
        return NO;
    }
    
    if ([text isEqualToString:@"\n"]) {
        [textViews resignFirstResponder];
        return NO;
    }

    return YES;
}
@end
