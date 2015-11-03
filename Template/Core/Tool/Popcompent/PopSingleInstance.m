//
//  WarnSingleInstance.m
//  XF9H-HD
//
//  Created by liyuchang on 14-11-12.
//  Copyright (c) 2014年 com.Vacn. All rights reserved.
//

#import "PopSingleInstance.h"
#import "PopWindow.h"
@interface PopSingleInstance ()
@property (nonatomic,strong) NSMutableArray *netWorkArr;
@property (nonatomic,strong) NSMutableArray *waitArr;
@end

@implementation PopSingleInstance
- (instancetype)init
{
    self = [super init];
    if (self) {
        _netWorkArr = [NSMutableArray array];
        _waitArr = [NSMutableArray array];
    }
    return self;
}
-(void)setSuspended:(BOOL)suspend
{
    _isSuspend = suspend;
}
-(BOOL)isSuspend
{
    return _isSuspend;
}
+(PopSingleInstance *)warSingleInstance
{
    @synchronized(self)
    {
        static PopSingleInstance *share;
        if (!share) {
            share = [[PopSingleInstance alloc] init];
        }
        return share;
    }
}

+(void)ShowWarn:(PopWindow *)window
{
    __weak PopSingleInstance *instance = [PopSingleInstance warSingleInstance];
    if ([instance isSuspend]) {
        return;
    }
    @synchronized(instance)
    {
        if (window.joinQueue) {
            __weak PopWindow *tempWindow;
            __weak PopWindow *temp2 = window;
            switch ([window decsription]) {
                case Wait:
                    tempWindow = [instance.waitArr lastObject];
                    [instance.waitArr addObject:window];
                    break;
                case NetWork:
                    tempWindow = [instance.netWorkArr lastObject];
                    [instance.netWorkArr addObject:window];
                    break;
                default:
                    break;
            }
            if (tempWindow&&tempWindow.isShow) {
                NSLog(@"1");
                tempWindow.next = ^{
                    [instance show:temp2];
                };
            }else
            {
                if (tempWindow&&!tempWindow.isShow) {
                    switch ([window decsription]) {
                        case Wait:
                            [instance.waitArr removeObject:tempWindow];
                            break;
                        case NetWork:
                            [instance.netWorkArr removeObject:tempWindow];
                            break;
                        default:
                            break;
                    }
                }
                [instance show:window];
            }
            
        }else
            [instance show:window];
    }
}

+(void)forceDismissWin:(PopWindow *)win
{
    PopSingleInstance *instance = [PopSingleInstance warSingleInstance];
    @synchronized(instance)
    {
        [instance hidden:win];
    }
}

-(void)show:(PopWindow *)wins
{
    __weak PopWindow *win = wins;
    __weak PopSingleInstance *instance = self;
    [win makeKeyAndVisible];
    win.transform = CGAffineTransformMakeScale(0.8, 0.8);
    win.alpha = 0;
    @synchronized(self)
    {
        win.isShow = YES;
    }
    [UIView animateWithDuration:win.animate?animatetime:0 animations:^{
        win.transform = CGAffineTransformIdentity;
        win.alpha = 1;
    } completion:^(BOOL finished) {
        if (win.time!=0) {
            [instance performSelector:@selector(hidden:) withObject:win afterDelay:win.time];
        }
    }];
}

-(void)hidden:(PopWindow *)wins
{
    __weak PopWindow *win = wins;
    [UIView animateWithDuration:win.animate?animatetime:0 animations:^{
        win.transform = CGAffineTransformMakeScale(0.8, 0.8);
        win.alpha = 0.0;
    } completion:^(BOOL finished) {
        @synchronized(self)
        {
            win.isShow = NO;
            if (win.joinQueue && win.next) {
                win.next();
            }
            [win resignKeyWindow];
            win.hidden = YES;
        }
        
    }];
}
@end
