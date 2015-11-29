//
//  MJRefreshTableFooterView.h
//  MJRefresh
//
//  Created by mj on 13-2-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  上拉加载更多

#import "MJRefreshBaseView.h"

@interface MJRefreshFooterView : MJRefreshBaseView
+ (instancetype)footer;
/*
 parame:zeroContentInset 加赞完毕是否显示额外的64px的bottominset,YES不显示，NO显示，默认no
 */
- (void)endRefreshing:(BOOL)zeroContentInset;
- (void)setRefreshNoInset;
@end