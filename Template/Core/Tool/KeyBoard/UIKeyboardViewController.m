//
//  LLabelsController.h
//  eisookom
//
//  Created by eisoo on 13-12-10.
//  Copyright (c) 2013年 eisoo. All rights reserved.
//
#import "UIKeyboardViewController.h"
#import "Define.h"
static CGFloat kboardHeight = 254.0f;
//static CGFloat spacerY = 0.0f;
static CGFloat viewFrameY = 0;

@interface UIKeyboardViewController () 

- (void)animateView:(BOOL)isShow textField:(id)textField heightforkeyboard:(CGFloat)kheight;
- (void)addKeyBoardNotification;
- (void)removeKeyBoardNotification;
- (void)checkBarButton:(id)textField;
- (id)firstResponder:(UIView *)navView;
- (NSArray *)allSubviews:(UIView *)theView;
- (void)resignKeyboard:(UIView *)resignView;

@end

@implementation UIKeyboardViewController

@synthesize boardDelegate = _boardDelegate;

- (void)dealloc {
    [objectView release];
    _boardDelegate = nil;
	[self removeKeyBoardNotification];
	[super dealloc];
}

//监听键盘隐藏和显示事件
- (void)addKeyBoardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
}

//注销监听事件
- (void)removeKeyBoardNotification {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//计算当前键盘的高度
-(void)keyboardWillShowOrHide:(NSNotification *)notification {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
#endif
		kboardHeight = 264.0f + _keyBoardToolbarHeight;
	}
    
	NSValue *keyboardBoundsValue;
	keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
	[keyboardBoundsValue getValue:&keyboardBounds];
    BOOL isShow = [[notification name] isEqualToString:UIKeyboardWillShowNotification] ? YES : NO;
	if ([self firstResponder:objectView]) { 
		[self animateView:isShow textField:[self firstResponder:objectView]
		heightforkeyboard:keyboardBounds.size.height];
	}
    
}

//输入框上移防止键盘遮挡
- (void)animateView:(BOOL)isShow textField:(id)textField heightforkeyboard:(CGFloat)kheight {
    [self checkBarButton:textField];
    
	kboardHeight = kheight;
    if ([textField isKindOfClass:[UITextView class]]) {
        UITextView *ttV=(id)textField;
        CGPoint offset=ttV.contentOffset;
        offset.y=ttV.contentSize.height-ttV.frame.size.height;
        if (ttV.contentSize.height>ttV.frame.size.height) {
            ttV.contentOffset=offset;
        }
    }
    
    UIScrollView *scroll=nil;
    if ([objectView isMemberOfClass:[UITableView class]]) {
        scroll = (UIScrollView *)objectView;
    }else
    {
        for (id view in [self allSubviews:objectView]) {
            if ([view isMemberOfClass:[UIScrollView class]]) {
                scroll=(UIScrollView *)view;
                if (scroll.contentSize.height>objectView.frame.size.height) {
                    break;
                }
            }
        }
    }
    
	__block CGRect rect = objectView.frame;
	[UIView animateWithDuration:0.3 animations:^(){
        if (isShow) {
            if (scroll==nil) {
                UIView *newView = ((UIView *)textField);
                CGPoint textPoint = [newView convertPoint:CGPointMake(0, newView.frame.size.height + self.spacerY) toView:objectView];
                if (rect.size.height - kheight < textPoint.y)
                    rect.origin.y = rect.size.height - kheight - textPoint.y + viewFrameY;
                else rect.origin.y = viewFrameY;
            }else if(scroll!=nil)
            {
                UIView *newView = ((UIView *)textField);
                CGPoint textPoint = [newView convertPoint:CGPointMake(0, newView.frame.size.height + self.spacerY) toView:scroll];
                CGPoint point = scroll.contentOffset;
                textPoint.y-=point.y;
                
                if (rect.size.height - kheight < textPoint.y)//在屏幕外
                {
                    rect.origin.y = rect.size.height - kheight - textPoint.y +viewFrameY;
                    if (rect.size.height<textPoint.y) {
                        rect.origin.y = rect.size.height - kheight - textPoint.y +viewFrameY+(textPoint.y-rect.size.height);
                    }else
                        rect.origin.y = rect.size.height - kheight - textPoint.y +viewFrameY;
                }
                else
                {
                    rect.origin.y = viewFrameY;
                }
                
                if (field!=nil&&[field isEqual:textField]) {
                    CGPoint offset=CGPointZero;
                    offset.y=416+def_addHeight-textPoint.y-rect.origin.y;
                    scroll.contentOffset=offset;
                }else
                    if (rect.size.height<textPoint.y) {//滚动内容是否在屏幕外，在外则滚动scroll
                        CGPoint offset=CGPointZero;
                        offset.y=textPoint.y-rect.size.height;
                        offset.y+=scroll.contentOffset.y;
                        NSValue *value=[NSValue valueWithCGPoint:offset];
                        NSLog(@"%@",value);
                        scroll.contentOffset=offset;
                    }
            }

        }
        else rect.origin.y = viewFrameY;
        objectView.frame = rect;
    } completion:^(BOOL finish){
    
        if (isShow) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KEYBOARDWILLSHOW object:[NSValue valueWithCGRect:rect]];
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:KEYBOARDWILLHIDDEN object:[NSValue valueWithCGRect:rect]];
        }
    }];
}

//输入框获得焦点
- (id)firstResponder:(UIView *)navView {

	for ( id aview in [self allSubviews:navView]) {
        if ([aview isKindOfClass:[UITextField class]] && [(UITextField *)aview isFirstResponder]) {
            return (UITextField *)aview;
            break;
        }
        else if ([aview isKindOfClass:[UITextView class]] && [(UITextView *)aview isFirstResponder]) {
            return (UITextView *)aview;
            break;
        }
    }
    return nil;
}

//找出所有的subview
- (NSArray *)allSubviews:(UIView *)theView {
	NSArray *results = [theView subviews];
	for (UIView *eachView in [theView subviews]) {
		NSArray *riz = [self allSubviews:eachView];
		if (riz) {
			results = [results arrayByAddingObjectsFromArray:riz];
		}
	}
	return results;
}

//输入框失去焦点，隐藏键盘
- (void)resignKeyboard:(UIView *)resignView {
	[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

//设置previousBarItem或nextBarItem是否允许点击
- (void)checkBarButton:(id)textField {
	int i = 0,j = 0;
	UIBarButtonItem *previousBarItem = [keyboardToolbar itemForIndex:0];
    UIBarButtonItem *nextBarItem = [keyboardToolbar itemForIndex:1];
	for (id aview in [self allSubviews:objectView]) {
		if ([aview isKindOfClass:[UITextField class]] && ((UITextField*)aview).userInteractionEnabled && ((UITextField*)aview).enabled) {
			i++;
			if ([(UITextField *)aview isEqual:textField]) {
				j = i;
			}
		}
		else if ([aview isKindOfClass:[UITextView class]] && ((UITextView*)aview).userInteractionEnabled && ((UITextView*)aview).editable) {
			i++;
			if ([(UITextView *)aview isEqual:textField]) {
				j = i;
			}
		}
	}
	[previousBarItem setEnabled:j > 1 ? YES : NO];
	[nextBarItem setEnabled:j < i ? YES : NO];
}

//toolbar button点击事件
#pragma mark - UIKeyboardView delegate methods
-(void)toolbarButtonTap:(UIButton *)button {
	NSInteger buttonTag = button.tag;
	NSMutableArray *textFieldArray=[NSMutableArray arrayWithCapacity:10];
	for (id aview in [self allSubviews:objectView]) {
		if ([aview isKindOfClass:[UITextField class]] && ((UITextField*)aview).userInteractionEnabled && ((UITextField*)aview).enabled) {
            UITextField *vv=(UITextField *)aview;
            if (vv.enabled==YES) {
                [textFieldArray addObject:(UITextField *)aview];
            }
			
		}
		else if ([aview isKindOfClass:[UITextView class]] && ((UITextView*)aview).userInteractionEnabled && ((UITextView*)aview).editable) {
            UITextView *vv=(UITextView *)aview;
            if (vv.editable==YES) {
                [textFieldArray addObject:(UITextView *)aview];
            }
		}
	}
	for (int i = 0; i < [textFieldArray count]; i++) {
		id textField = [textFieldArray objectAtIndex:i];
		if ([textField isKindOfClass:[UITextField class]]) {
			textField = ((UITextField *)textField);
		}
		else {
			textField = ((UITextView *)textField);
		}
		if ([textField isFirstResponder]) {
			if (buttonTag == 1) {
				if (i > 0) {
					[[textFieldArray objectAtIndex:--i] becomeFirstResponder];
					[self animateView:YES textField:[textFieldArray objectAtIndex:i] heightforkeyboard:kboardHeight];
				}
			}
			else if (buttonTag == 2) {
				if (i < [textFieldArray count] - 1) {
					[[textFieldArray objectAtIndex:++i] becomeFirstResponder];
					[self animateView:YES textField:[textFieldArray objectAtIndex:i] heightforkeyboard:kboardHeight];
				}
			}
		}
	}
	if (buttonTag == 3) 
		[self resignKeyboard:objectView];
}

-(void)simulateClickBarButton:(id)textField
{
    [self checkBarButton:textField];
}
-(void)rollToTop:(UITextField *)fx
{
    field=fx;
}

#pragma mark - TextField delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
	[self checkBarButton:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ([self.boardDelegate respondsToSelector:@selector(alttextFieldDidEndEditing:)]) {
		[self.boardDelegate alttextFieldDidEndEditing:textField];
	}
}

#pragma mark - UITextView delegate methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {    
	if ([text isEqualToString:@"\n"]) {    
		[textView resignFirstResponder];    
		return NO;    
	}
	return YES;    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	if ([self.boardDelegate respondsToSelector:@selector(alttextViewDidEndEditing:)]) {
		[self.boardDelegate alttextViewDidEndEditing:textView];
	}
}

@end

@implementation UIKeyboardViewController (UIKeyboardViewControllerCreation)

- (id)initWithControllerDelegate:(id)delegateObject {
	if (self = [super init]) {
		self.boardDelegate = delegateObject;
        if ([self.boardDelegate isKindOfClass:[UIViewController class]]) {
			objectView = [(UIViewController *)[self boardDelegate] view];
		}
		else if ([self.boardDelegate isKindOfClass:[UIView class]]) {
			objectView = (UIView *)[self boardDelegate];
		}
        [objectView retain];
        viewFrameY = objectView.frame.origin.y;
		[self addKeyBoardNotification];
	}
	return self;
}

@end

@implementation UIKeyboardViewController (UIKeyboardViewControllerAction)

//给键盘加上toolbar
- (void)addToolbarToKeyboard {
	keyboardToolbar = [[UIKeyboardView alloc] initWithFrame:CGRectMake(0, 0, objectView.frame.size.width, _keyBoardToolbarHeight)];
	keyboardToolbar.delegate = self;
	for (id aview in [self allSubviews:objectView]) {
		if ([aview isKindOfClass:[UITextField class]]) {
			((UITextField *)aview).inputAccessoryView = keyboardToolbar;
//			((UITextField *)aview).delegate = self;
		}
		else if ([aview isKindOfClass:[UITextView class]]) {
			((UITextView *)aview).inputAccessoryView = keyboardToolbar;
//			((UITextView *)aview).delegate = self;
		}
        [self checkSubViews:aview];
	}
}

-(void)checkSubViews:(id)view
{
    NSArray *subs=[(UIView *)view subviews];
    if ([view isKindOfClass:[UITextField class]]) {
        ((UITextField *)view).inputAccessoryView = keyboardToolbar;
       // ((UITextField *)view).delegate = self;
    }
    else if ([view isKindOfClass:[UITextView class]]) {
        ((UITextView *)view).inputAccessoryView = keyboardToolbar;
        //((UITextView *)view).delegate = self;
    }
    if ([subs count]!=0) {
        for (id bviews  in subs){
            [self checkSubViews:bviews];
        }
    }
}

@end
