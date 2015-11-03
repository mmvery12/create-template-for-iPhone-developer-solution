//
//  Verify.h
//  NiuBXiChe
//
//  Created by Mac on 14-8-3.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Verify : NSObject
+(BOOL)VerifyPhone:(NSString *)string;
+(BOOL)VerifyPassWord:(NSString *)string;
+(BOOL)VerifyVerify:(NSString *)string;
+(BOOL)VerifyName:(NSString *)string;
+(BOOL)VerifyVerifyNum:(NSString *)string;
+ (BOOL) validateEmail:(NSString *)email;
@end
