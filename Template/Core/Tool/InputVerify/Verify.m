//
//  Verify.m
//  NiuBXiChe
//
//  Created by Mac on 14-8-3.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "Verify.h"

@implementation Verify
+(BOOL)VerifyPhone:(NSString *)string
{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL)VerifyPassWord:(NSString *)string
{
    NSString *regex = @"^[\\@A-Za-z0-9\\!\\#\\$\\%\\^\\&\\*\\.\\~]{6,12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}
+(BOOL)VerifyVerify:(NSString *)string
{
    NSString *regex = @"^\\d{4}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}
+(BOOL)VerifyName:(NSString *)string
{
    return string.length>1?YES:false;
}

+(BOOL)VerifyVerifyNum:(NSString *)string
{
    return string.length>=4?YES:NO;
}
@end
