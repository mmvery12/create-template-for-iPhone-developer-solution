//
//  URLScheme.h
//  NiuBXiChe
//
//  Created by liyuchang on 14-8-1.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RequestObj.h"
#import "AFNetworking.h"
#import "RequestResponseScheme.h"
#import "ResponseObj.h"
#import "JSONKit.h"

typedef void (^SuccessBlock)(NSDictionary *responseData);
typedef void (^FaildBlock)(void);
typedef void (^ParamsErrorBlock)(NSString *str);
typedef void (^SpecialBlock)(void);

@interface URLScheme : NSObject

+(AFHTTPRequestOperation *)urlGet:(NSString *)url params:(RequestObj *)obj success:(SuccessBlock)successBlock paramsError:(ParamsErrorBlock)paramsErrorBlock faild:(FaildBlock)falidBlock final:(SpecialBlock)final;

+(AFHTTPRequestOperation *)urlPost:(NSString *)url params:(RequestObj *)obj success:(SuccessBlock)successBlock paramsError:(ParamsErrorBlock)paramsErrorBlock faild:(FaildBlock)falidBlock final:(SpecialBlock)final;
+(void)CancelRequestOperation:(AFHTTPRequestOperation *)operation;
@end
