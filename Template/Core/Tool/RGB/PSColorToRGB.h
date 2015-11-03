//
//  PSColorToRGB.h
//  LuckyCommunity
//
//  Created by liyuchang on 14-6-23.
//  Copyright (c) 2014年 VACN. All rights reserved.
//

/**@file
 * @brief   PSColor to RGB工具类
 * @author  李煜昌
 * @date    2014-07-21
 * @version 1.0
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PSColorToRGB : NSObject
/** @brief 这个方法是将ps的#******16位颜色转换位RGB的颜色 */
+(UIColor *) getColor: (NSString *) stringToConvert;
@end
