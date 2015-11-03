//
//  PingPayAction.h
//  HuLuWa
//
//  Created by liyuchang on 15/6/25.
//  Copyright (c) 2015年 liyuchang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PingPayChannel) {
    WXPay = 1,
    AliPay,
    Upacp,
    Bfb
};

typedef NS_ENUM(NSInteger, FaildStatus)
{
    ParameterFaild = 1,
    PayFaild ,
    NetFaild
};

typedef void(^Block)(void);
typedef void(^FaildCallBlock) (FaildStatus faildStatus, NSString *msg);
/**
    不支持pay并发请求,程序未做锁,并发发生时会产生错误
 */
@interface PingPayAction : NSObject
+(void)PingPay:(RequestObj *)request channel:(PingPayChannel)channel success:(Block)success faild:(FaildCallBlock)faild final:(Block)final;
+(void)PingPayHandelURL:(NSURL *)url;

@end
