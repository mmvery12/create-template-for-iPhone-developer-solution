//
//  LLabelsController.h
//  eisookom
//
//  Created by eisoo on 13-12-10.
//  Copyright (c) 2013年 eisoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIKeyboardViewDelegate;

@interface UIKeyboardView : UIView {
	id <UIKeyboardViewDelegate> _delegate;
	UIToolbar *keyboardToolbar;
}

@property (nonatomic, assign) id <UIKeyboardViewDelegate> delegate;

@end

@interface UIKeyboardView (UIKeyboardViewAction)

- (UIBarButtonItem *)itemForIndex:(NSInteger)itemIndex;

@end

@protocol UIKeyboardViewDelegate <NSObject>

- (void)toolbarButtonTap:(UIButton *)button;

@optional

@end
