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
    [URLScheme loadCookies];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"mobile-ios" forHTTPHeaderField:@"User-Agent"];
    manager.requestSerializer.timeoutInterval = 60;
    manager.requestSerializer.cachePolicy=NSURLRequestReloadIgnoringCacheData;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    {
        NSString *strcookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionCookies"];
        if (strcookie && [strcookie isKindOfClass:[NSString class]]) {
            [manager.requestSerializer setValue:strcookie forHTTPHeaderField:@"Cookie"];
            url = [url stringByAppendingString:[NSString stringWithFormat:@";%@",strcookie]];
        }
        

    }
    return [manager GET:url parameters:[obj getRequestParmars] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        {
            NSDictionary *fields= [operation.response allHeaderFields];
            NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:OpenURL]];
            NSDictionary* requestFields=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
            [[NSUserDefaults standardUserDefaults] setObject:[requestFields objectForKey:@"Cookie"] forKey:@"sessionCookies"];
        }
        
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
    {
        NSString *strcookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionCookies"];
        if (strcookie && [strcookie isKindOfClass:[NSString class]]) {
            [manager.requestSerializer setValue:strcookie forHTTPHeaderField:@"Cookie"];
            url = [url stringByAppendingString:[NSString stringWithFormat:@";%@",strcookie]];
        }
    }
    
    return [manager POST:OpenURL parameters:[obj getRequestParmars] constructingBodyWithBlock:^(id formData) {
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"abc"] name:[NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]] error:nil];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        {
            NSDictionary *fields= [operation.response allHeaderFields];
            NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:OpenURL]];
            NSDictionary* requestFields=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
            [[NSUserDefaults standardUserDefaults] setObject:[requestFields objectForKey:@"Cookie"] forKey:@"sessionCookies"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [PopViewOfNetWork ShowWarnNoNetClient:@"无法连接服务器" during:2 joinQueue:YES animate:YES];
        final();
        falidBlock();
    }];
    
    

//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer.timeoutInterval = 60;
//    manager.requestSerializer.cachePolicy=NSURLRequestReloadIgnoringCacheData;
//    [manager.requestSerializer setValue:@"mobile-ios" forHTTPHeaderField:@"User-Agent"];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [URLScheme loadCookies];
//    {
//        NSString *strcookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionCookies"];
//        if (strcookie && [strcookie isKindOfClass:[NSString class]]) {
//            [manager.requestSerializer setValue:strcookie forHTTPHeaderField:@"Cookie"];
//            url = [url stringByAppendingString:[NSString stringWithFormat:@";%@",strcookie]];
//        }
//    }
//    
//    return [manager POST:url parameters:[obj getRequestParmars] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        {
//            NSDictionary *fields= [operation.response allHeaderFields];
//            NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:OpenURL]];
//            NSDictionary* requestFields=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
//            [[NSUserDefaults standardUserDefaults] setObject:[requestFields objectForKey:@"Cookie"] forKey:@"sessionCookies"];
//        }
//        
//        [URLScheme saveCookies];
//        NSString *msg = [RequestResponseScheme responseURL:responseObject];
//        if (msg) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
//            [alert show];
//            final();
//            paramsErrorBlock(msg);
//        }else
//        {
//            final();
//            successBlock(responseObject);
//        }
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [PopViewOfNetWork ShowWarnNoNetClient:@"无法连接服务器" during:2 joinQueue:YES animate:YES];
//        final();
//        falidBlock();
//    }];

}

+(AFHTTPRequestOperation *)urlPostData:(NSString *)url params:(EntityBase *)obj data:(NSString *)fileurl success:(SuccessBlock)successBlock paramsError:(ParamsErrorBlock)paramsErrorBlock faild:(FaildBlock)falidBlock final:(SpecialBlock)final;

{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 60;
    manager.requestSerializer.cachePolicy=NSURLRequestReloadIgnoringCacheData;
    [manager.requestSerializer setValue:@"mobile-ios" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    [URLScheme loadCookies];
    {
        NSString *strcookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionCookies"];
        if (strcookie && [strcookie isKindOfClass:[NSString class]]) {
            [manager.requestSerializer setValue:strcookie forHTTPHeaderField:@"Cookie"];
            url = [url stringByAppendingString:[NSString stringWithFormat:@";%@",strcookie]];
        }
    }
    
    return [manager POST:OpenURL parameters:[obj getRequestParmars] constructingBodyWithBlock:^(id formData) {
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:fileurl] name:[NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]] error:nil];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        {
            NSDictionary *fields= [operation.response allHeaderFields];
            NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:OpenURL]];
            NSDictionary* requestFields=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
            [[NSUserDefaults standardUserDefaults] setObject:[requestFields objectForKey:@"Cookie"] forKey:@"sessionCookies"];
        }
        
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    [defaults setObject: cookiesData forKey: @"sessionCookies2"];
    [defaults synchronize];
    
}

+ (NSArray *)loadCookies{
    
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies2"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies){
        [cookieStorage setCookie: cookie];
    }
    return cookies;
}


+(void)clearSession;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"sessionCookies"];
    [defaults setObject:@"" forKey:@"sessionCookies2"];
    [defaults removeObjectForKey:@"sessionCookies2"];
    [defaults removeObjectForKey:@"sessionCookies"];
    [defaults synchronize];
}
@end
