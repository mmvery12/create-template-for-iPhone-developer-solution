//
//  EntityBase.h
//  E-Kubao
//
//  Created by liyuchang on 15/5/13.
//  Copyright (c) 2015年 lianlianchuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EntiyDelegate <NSObject>
-(NSDictionary *)paramsSpecialNameConvertAdapter;
-(NSDictionary *)arrayContainObjIsEntyBaseObjNeedToEncode;
@end

@class EntityBase;
typedef id (^vaildEntityBlock) (EntityBase *entity);
@interface EntityBase : NSObject<NSCopying,NSCoding,EntiyDelegate>

/*
 基类中已自动按照.h设置的属性，全文赋值，
 warn：当a文件中包含b，b中包含a时，请使用手动赋值，
 */
-(id)initResponseObjfromData:(id)data;


/*
 手动赋值时，遍历，为nsnull或nil设置
 */
- (BOOL)manualPaddingParamsValues:(NSObject*)dataSource;

/*
 getRequsetDatafromObj ，将对象反解为字典使用的方法
 isVaildRequestObject，
 */
-(id)getRequsetDatafromObj;
-(id)isVaildRequestObject:(NSObject *)object;

-(id)getRequestParmars;
@end
