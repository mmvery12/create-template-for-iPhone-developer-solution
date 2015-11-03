//
//  TextView.h
//  HuLuWa
//
//  Created by liyuchang on 15/5/25.
//  Copyright (c) 2015年 liyuchang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextView;

@protocol TextViewDelegate <NSObject>
@required
-(void)textViewDidChanges:(TextView *)textView;
@end

@interface TextView : UIView<UITextViewDelegate>
@property (nonatomic,retain)NSString *text;
@property (nonatomic,retain)UIColor *textColor;
@property (nonatomic,retain)UIFont *font;
@property (nonatomic,assign)UIReturnKeyType returnType;
@property (nonatomic,weak) id <TextViewDelegate> textViewDelegate;
- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font count:(NSInteger)count def:(NSString *)str;
@end
