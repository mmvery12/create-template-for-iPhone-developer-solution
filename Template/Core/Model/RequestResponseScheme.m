//
//  RepuestResponseScheme.m
//  NiuBXiChe
//
//  Created by liyuchang on 14-8-1.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RequestResponseScheme.h"
#import "URLScheme.h"
#import "JSONKit.h"
@implementation RequestResponseScheme

//+(NSString *)responseURL:(NSDictionary *)data
//{
//    NSDictionary  *temp = [NSDictionary dictionaryWithDictionary:data];
//    NSDictionary *rtnStatus = [temp objectForKey:@"rtnStatus"];
//    NSString *code =[rtnStatus objectForKey:@"code"];
//    if (temp==nil) {
//        return @"服务器正忙,请稍后重试!";
//    }
//    if (code.integerValue == 200) {
//        return nil;
//    }
//    return [rtnStatus objectForKey:@"message"];
//}

+(NSString *)responseURL:(NSDictionary *)data
{
    NSDictionary  *temp = [NSDictionary dictionaryWithDictionary:data];
    NSString *code =[temp objectForKey:@"code"];
    if (temp==nil) {
        return @"服务器正忙,请稍后重试!";
    }
    if (!code ||[code isKindOfClass:[NSNull class]] || code.length==0) {
        return nil;
    }
    if ([code isEqual:@"F_300"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KsesionLogout" object:nil];
    }
    return [temp objectForKey:@"message"];
}
@end
