	//
//  URLScheme.m
//  NiuBXiChe
//
//  Created by liyuchang on 14-8-1.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "URLScheme.h"

@implementation URLScheme


+(AFHTTPRequestOperation *)urlGet:(NSString *)url params:(EntityBase *)obj success:(SuccessBlock)successBlock paramsError:(ParamsErrorBlock)paramsErrorBlock faild:(FaildBlock)falidBlock final:(SpecialBlock)final
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"mobile-ios" forHTTPHeaderField:@"User-Agent"];
    manager.requestSerializer.timeoutInterval = 60;
    manager.requestSerializer.cachePolicy=NSURLRequestReloadIgnoringCacheData;
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    [URLScheme loadCookies];
    return [manager GET:url parameters:[obj getRequestParmars] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [URLScheme saveCookies];
        NSString *msg = [RequestResponseScheme responseURL:responseObject];
        if (msg) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
            final();
            paramsErrorBlock(msg);
        }else
        {
            final();
            successBlock(responseObject);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        final();
        falidBlock();
    }];
}

+(AFHTTPRequestOperation *)urlPost:(NSString *)url params:(EntityBase *)obj success:(SuccessBlock)successBlock paramsError:(ParamsErrorBlock)paramsErrorBlock faild:(FaildBlock)falidBlock final:(SpecialBlock)final
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 60;
    manager.requestSerializer.cachePolicy=NSURLRequestReloadIgnoringCacheData;
    [manager.requestSerializer setValue:@"mobile-ios" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    [URLScheme loadCookies];
    
    return [manager POST:url parameters:[obj getRequestParmars] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [URLScheme saveCookies];
        NSString *msg = [RequestResponseScheme responseURL:responseObject];
        if (msg) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
            final();
            paramsErrorBlock(msg);
        }else
        {
            final();
            successBlock(responseObject);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [PopViewOfNetWork ShowWarnNoNetClient:@"无法连接服务器" during:2 joinQueue:YES animate:YES];
        final();
        falidBlock();
    }];

}
+(void)CancelRequestOperation:(AFHTTPRequestOperation *)operation
{
    if (operation && [operation respondsToSelector:@selector(cancel)]) {
        [operation cancel];
    }
}


+ (void)saveCookies{
    
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey: @"sessionCookies"];
    [defaults synchronize];
    
}

+ (void)loadCookies{
    
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies){
        [cookieStorage setCookie: cookie];
    }
    
}
@end
