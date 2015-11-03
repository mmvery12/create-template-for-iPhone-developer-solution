//
//  LLabelsController.h
//  eisookom
//
//  Created by eisoo on 13-12-10.
//  Copyright (c) 2013年 eisoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardView.h"
#define KEYBOARDWILLSHOW @"KEYBOARDWILLSHOW"
#define KEYBOARDWILLHIDDEN @"KEYBOARDWILLHIDDEN"

@protocol UIKeyboardViewControllerDelegate;



typedef enum {
    toolBarClick=0,
    simulaterClick=1
}TypeOfClik;
@interface UIKeyboardViewController : NSObject <UITextFieldDelegate, UIKeyboardViewDelegate, UITextViewDelegate> {
	CGRect keyboardBounds;
	UIKeyboardView *keyboardToolbar;
//    id  _boardDelegate;//<UIKeyboardViewControllerDelegate>
    UIView *objectView;
    
    //roll to top
    UITextField *field;
}

@property (nonatomic,assign)id<UIKeyboardViewControllerDelegate> boardDelegate;
-(void)rollToTop:(UITextField *)fx;
//- (void)checkBarButton:(id)textField;
-(void)simulateClickBarButton:(id)textField;
/**
 spaceY ,键盘输入空间距离keyboard高度
 */
@property (nonatomic, assign) CGFloat spacerY; //default 0.0f
/**
 keyBoardToolbarHeight ,输入空间accessview高度
 */
@property (nonatomic, assign) CGFloat keyBoardToolbarHeight;
@end














@interface UIKeyboardViewController (UIKeyboardViewControllerCreation)

- (id)initWithControllerDelegate:(id)delegateObject;

@end

@interface UIKeyboardViewController (UIKeyboardViewControllerAction)

- (void)addToolbarToKeyboard;

@end

@protocol UIKeyboardViewControllerDelegate <NSObject>

@optional

- (void)alttextFieldDidEndEditing:(UITextField *)textField;
- (void)alttextViewDidEndEditing:(UITextView *)textView;

@end
