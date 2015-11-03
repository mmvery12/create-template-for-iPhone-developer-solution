//
//  TImeConvert.h
//  LuckyCommunity
//
//  Created by liyuchang on 14-6-27.
//  Copyright (c) 2014年 VACN. All rights reserved.
//
/**@file
 * @brief   时间戳string转化具体日期工具类
 * @author  李煜昌
 * @date    2014-07-21
 * @version 1.0
 */
#import <Foundation/Foundation.h>

@interface TImeConvert : NSObject
/** @brief 这个方法是将时间戳转为MM-dd HH:mm:ss形式*/
+(NSString *)getFormatTime:(long long)time;
/** @brief 这个方法是将时间戳转为yyyy/MM/dd HH:mm:ss形式*/
+(NSString *)getFormatTime2:(long long)time;

+(NSString *)getFormattime3:(NSDate *)date;

+(NSString *)getFormattime4:(long long)time;

+(NSString *)getFormattime5:(long long)time;

+(NSString *)getTime:(long long)time Format:(NSString *) format;
+(NSDate *)getDateFromString:(NSString *)str;
+(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month;
+(NSString *)daylyConvert:(long long)begin end:(long long)end;
@end
