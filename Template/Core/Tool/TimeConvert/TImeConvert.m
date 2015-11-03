//
//  TImeConvert.m
//  LuckyCommunity
//
//  Created by liyuchang on 14-6-27.
//  Copyright (c) 2014年 VACN. All rights reserved.
//
/**@class
 * @brief 时间戳转化具体事件实现
 * @author 李煜昌
 * @date   2014-07-21
 * @version 1.0
 */
#import "TImeConvert.h"

@implementation TImeConvert
/**
 * @brief  将时间戳转为MM-dd HH:mm:ss形式
 * @author 王平平
 * @date   2014-5-28
 * @version 1.0
 * @param  无参数
 * @return time 时间戳
 * @note   特别标注，一般不加
 */
+(NSString *)getFormatTime:(long long)time
{
    NSString *temp=[NSString stringWithFormat:@"%lld",time];
//    NSRange range=NSMakeRange(0, 10);
    if (temp.length>10) {
//        temp = [temp substringWithRange:range];
        time = [temp longLongValue]/1000;
        
    }else
        time=[temp longLongValue];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

/**
 * @brief  将时间戳转为yyyy/MM/dd HH:mm:ss形式
 * @author 王平平
 * @date   2014-5-28
 * @version 1.0
 * @param  无参数
 * @return time 时间戳
 * @note   特别标注，一般不加
 */
+(NSString *)getFormatTime2:(long long)time
{
    NSString *temp=[NSString stringWithFormat:@"%lld",time];
    if (temp.length>10) {
        time = [temp longLongValue]/1000;
    }else
        time = [temp longLongValue];
    time=[temp longLongValue];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+(NSString *)getFormattime3:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+(NSString *)getFormattime4:(long long)time
{
    NSString *temp=[NSString stringWithFormat:@"%lld",time];
    if (temp.length>10) {
        time = [temp longLongValue]/1000;
    }else
        time = [temp longLongValue];

    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
/**
 * @brief  将时间戳转为yyyy/MM/dd HH:mm:ss形式
 * @author 王平平
 * @date   2014-5-28
 * @version 1.0
 * @param  无参数
 * @return time 时间戳
 * @note   特别标注，一般不加
 */
+(NSString *)getTime:(long long)time Format:(NSString *) format
{
    NSString *temp=[NSString stringWithFormat:@"%lld",time];
//    NSRange range=NSMakeRange(0, 10);
    if (temp.length>10) {
//        time=[temp longLongValue];
                time = [temp longLongValue]/1000;
    }else
        time = [temp longLongValue];

    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}



//计算两个日期之间的天数
+(NSString *)daylyConvert:(long long)begin end:(long long)end
{
    {
        NSString *temp=[NSString stringWithFormat:@"%lld",begin];
//        NSRange range=NSMakeRange(0, 10);
        if (temp.length>10) {
//        time=[temp longLongValue];
                    begin = [temp longLongValue]/1000;
        }else
            begin=[temp longLongValue];
    }
    
    {
        NSString *temp=[NSString stringWithFormat:@"%lld",end];
//        NSRange range=NSMakeRange(0, 10);
        if (temp.length>10) {
                    end = [temp longLongValue]/1000;
//            temp = [temp substringWithRange:range];
        }else
            end=[temp longLongValue];
    }
    
    
    
    
    NSDate *inBegin = [NSDate dateWithTimeIntervalSince1970:begin];
    NSDate *inEnd = [NSDate dateWithTimeIntervalSince1970:end];
    NSInteger unitFlags = NSDayCalendarUnit| NSMonthCalendarUnit | NSYearCalendarUnit;
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [cal components:unitFlags fromDate:inBegin];
    NSDate *newBegin  = [cal dateFromComponents:comps];

    
    NSCalendar *cal2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps2 = [cal2 components:unitFlags fromDate:inEnd];
    NSDate *newEnd  = [cal2 dateFromComponents:comps2];

    
    NSTimeInterval interval = [newEnd timeIntervalSinceDate:newBegin];
    NSInteger beginDays=((NSInteger)interval)/(3600*24);
    return [NSString stringWithFormat:@"%ld",beginDays];
//    return beginDays;
}

+(NSString *)getFormattime5:(long long)time
{
    NSString *temp=[NSString stringWithFormat:@"%lld",time];
//    NSRange range=NSMakeRange(0, 10);
    if (temp.length>10) {
//        temp = [temp substringWithRange:range];
        time = [temp longLongValue]/1000;
    }else
        time=[temp longLongValue];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}


+(NSDate *)getDateFromString:(NSString *)str
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:str];
    return date;
}

+(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month

{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
}


@end
