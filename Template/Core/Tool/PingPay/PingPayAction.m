//
//  PingPayAction.m
//  HuLuWa
//
//  Created by liyuchang on 15/6/25.
//  Copyright (c) 2015年 liyuchang. All rights reserved.
//

#import "PingPayAction.h"


@interface PingPayAction ()
@property (nonatomic,assign)NSInteger repeaceCount;
@property (nonatomic,assign)NSTimeInterval timeCutDown;//(begin)500ms, 1s, 2s(end)
@property (nonatomic,copy)Block success;
@property (nonatomic,copy)FaildCallBlock faild;
@property (nonatomic,copy)Block final;
//@property (nonatomic,retain)IsPaid_Request *req;
@property (nonatomic,retain)  PopViewOfWait *wait2;
@end

@implementation PingPayAction
+(id)ShareInstance
{
    static PingPayAction *share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [PingPayAction new];
    });
    return share;
}

//+(void)PingPay:(Charge_Request *)request channel:(PingPayChannel)channel success:(Block)success faild:(FaildCallBlock)faild final:(Block)final;
//{
//    
//    __weak PingPayAction *share = [PingPayAction ShareInstance];
//    share.repeaceCount = 5;
//    share.timeCutDown = 0.5;
//    share.success = success;
//    share.faild = faild;
//    share.final = final;
//    NSString *channelStr = nil;
//    switch (channel) {
//        case WXPay:
//            channelStr = @"wx";
//            break;
//        case AliPay:
//            channelStr = @"alipay";
//            break;
//        case Upacp:
//            assert(@"[ERROR]:application can not support this channel \"Upacp\"");
//            channelStr = @"upacp";
//            break;
//        case Bfb:
//            assert(@"[ERROR]:application can not support this channel \"bfb\"");
//            channelStr = @"bfb";
//            break;
//        default:
//            break;
//    }
//    request.channel = channelStr;
//    double amount = request.amount.doubleValue;
//    int amount_int_cents = amount*100;
//    request.amount = [NSNumber numberWithInteger:amount_int_cents];
//    __block PopViewOfWait *wait1 = [PopViewOfWait ShowWarnViewWaitingActivity:@"" animate:YES];
//    [URLScheme url:service_host params:request success:^(NSDictionary *responseData) {
//        share.wait2 = [PopViewOfWait ShowWarnViewWaitingActivity:@"" animate:YES];
//        __weak typeof(share.wait2) weakWait = share.wait2;
//        share.req = [[IsPaid_Request alloc] init];
//        share.req.orderId = request.orderNo;
//        share.req.chargeId = [[responseData objectForKey:@"data"] objectForKey:@"id"];
//        [Pingpp createPayment:[[responseData objectForKey:@"data"] JSONString] viewController:nil appURLScheme:pingpay_urlscheme withCompletion:^(NSString *result, PingppError *error) {
//            [PopSingleInstance forceDismissWin:weakWait];
//            if (error == nil) {
//                //VERIFTY
//                [share performSelector:@selector(verityPayCallBackIsPay:) withObject:share.req afterDelay:share.timeCutDown];
//            } else {
//                faild(PayFaild,[error getMsg]);
//                final();
//                NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
//            }
//
//        }];
//    } paramsError:^(NSString *str) {
//        faild(ParameterFaild,@"参数错误");
//    } faild:^{
//        faild(NetFaild,@"网络错误");
//    } final:^{
//        final();
//        [PopSingleInstance forceDismissWin:wait1];
//    }];
//}
//
//
//-(void)verityPayCallBackIsPay:(IsPaid_Request *)request
//{
//    if (_timeCutDown==2) {
//        _faild(PayFaild,@"支付无法验证");
//        _final();
//        return;
//    }
//    DECLARE_WEAK_SELF;
//    [URLScheme url:service_host params:request success:^(NSDictionary *responseData) {
//        NSDictionary *data = [NSDictionary dictionaryWithDictionary:[responseData objectForKey:@"data"]];
//        if (data) {
//            if ([[data objectForKey:@"isPaid"] boolValue]) {
//                _success();
//                _final();
//            }else
//            {
//                _timeCutDown*=2;
//                [weakSelf performSelector:@selector(verityPayCallBackIsPay:) withObject:request afterDelay:_timeCutDown];
//            }
//        }else
//            assert(@"[ERROR]:service response data without \"data\" params");
//    } paramsError:^(NSString *str) {
//        _faild(ParameterFaild,@"参数错误");
//        _final();
//    } faild:^{
//        if (weakSelf.repeaceCount==0) {
//            _faild(PayFaild,@"支付无法验证");
//            _final();
//        }else
//        {
//            weakSelf.repeaceCount--;
//            [weakSelf verityPayCallBackIsPay:request];
//        }
//
//    } final:^{
//        
//    }];;
//}
//
//
//+(void)PingPayHandelURL:(NSURL *)url;
//{
//    __weak PingPayAction *share = [PingPayAction ShareInstance];
//    [Pingpp handleOpenURL:url
//           withCompletion:^(NSString *result, PingppError *error) {
//               [PopSingleInstance forceDismissWin:share.wait2];
//               if ([result isEqualToString:@"success"]) {
//                   [share verityPayCallBackIsPay:share.req];
////                   share.success();
////                   share.final();
//                   // 支付成功
//               } else {
//                   share.faild(PayFaild,[error getMsg]);
//                   share.final();
//                   // 支付失败或取消
//                   NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
//               }
//           }];
//
//}
@end
