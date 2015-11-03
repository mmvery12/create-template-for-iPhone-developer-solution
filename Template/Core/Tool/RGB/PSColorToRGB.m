//
//  PSColorToRGB.m
//  LuckyCommunity
//
//  Created by liyuchang on 14-6-23.
//  Copyright (c) 2014年 VACN. All rights reserved.
//
/**@class
 * @brief PSColor to RGB实现
 * @author 李煜昌
 * @date   2014-07-21
 * @version 1.0
 */
#import "PSColorToRGB.h"

@implementation PSColorToRGB
/**
 * @brief  将pscolor转为uicolor
 * @author 李煜昌
 * @date   2014-7-21
 * @version 1.0
 * @param  stringToConvert psColorString
 * @return void
 */
+(UIColor *) getColor: (NSString *) stringToConvert
{
	NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
	if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
	NSRange range;
	range.location = 0;
	range.length = 2;
	NSString *rString = [cString substringWithRange:range];
	range.location = 2;
	NSString *gString = [cString substringWithRange:range];
	range.location = 4;
	NSString *bString = [cString substringWithRange:range];
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	return [UIColor colorWithRed:((float) r / 255.0f)
						   green:((float) g / 255.0f)
							blue:((float) b / 255.0f)
						   alpha:1.0f];
}
@end
