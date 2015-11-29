//
//  EntityBase.m
//  E-Kubao
//
//  Created by liyuchang on 15/5/13.
//  Copyright (c) 2015年 lianlianchuang. All rights reserved.
//

#import "EntityBase.h"
#import <objc/runtime.h>

@interface EntityBase ()
{
    id<EntiyDelegate> _delegate;
}
@property (nonatomic,retain)NSDictionary *paramsSpecialNameDict;
@property (nonatomic,retain)NSDictionary *arrayContainObjIsEntyBaseObjNeedToEncodeDict;
@end

@implementation EntityBase

- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = self;
        if ([_delegate respondsToSelector:@selector(paramsSpecialNameConvertAdapter)]) {
            _paramsSpecialNameDict = [NSDictionary dictionaryWithDictionary:[_delegate paramsSpecialNameConvertAdapter]] ;
        }
        else
            _paramsSpecialNameDict = @{};
        if ([_delegate respondsToSelector:@selector(arrayContainObjIsEntyBaseObjNeedToEncode)]) {
            _arrayContainObjIsEntyBaseObjNeedToEncodeDict = [NSDictionary dictionaryWithDictionary:[_delegate arrayContainObjIsEntyBaseObjNeedToEncode]];
        }else
            _arrayContainObjIsEntyBaseObjNeedToEncodeDict = @{};
        
    }
    return self;
}


-(NSDictionary *)paramsSpecialNameConvertAdapter
{
    return @{};
}

-(NSDictionary *)arrayContainObjIsEntyBaseObjNeedToEncode
{
    return @{};
}


-(id)getRequsetDatafromObj
{
    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
    for (NSDictionary *dict in [self getAllProperties]) {
        NSString *key = [dict objectForKey:@"name"];
        SEL getParamSel = NSSelectorFromString(key);
        id obj = [self performSelector:getParamSel];
        if ([[_arrayContainObjIsEntyBaseObjNeedToEncodeDict allKeys] containsObject:key]) {
            if ([obj isKindOfClass:[NSArray class]]||[obj isKindOfClass:[NSMutableArray class]]) {
                NSMutableArray *arr = [NSMutableArray array];
                for (id temp in obj) {
                    [arr addObject:[temp getRequsetDatafromObj]];
                }
                [temp setObject:arr forKey:key];
            }
        }else
            [temp setObject:[self isVaildRequestObject:obj] forKey:key];
    }
    return temp;
}


-(id)initResponseObjfromData:(id)data
{
    if (data==nil||[data isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if (self = [super init]) {
        _delegate = self;
        _paramsSpecialNameDict = [NSDictionary dictionaryWithDictionary:[_delegate paramsSpecialNameConvertAdapter]] ;
        _arrayContainObjIsEntyBaseObjNeedToEncodeDict = [NSDictionary dictionaryWithDictionary:[_delegate arrayContainObjIsEntyBaseObjNeedToEncode]];
        
        [self autoPaddingParamsValues:data];
    }
    return self;
}

-(id)isVaildRequestObject:(NSObject *)object
{
    if ([object isKindOfClass:[NSNull class]]||object==nil) {
        return [NSNull null];
    }
    if ([object isKindOfClass:[EntityBase class]]) {
        return [(EntityBase *)object getRequsetDatafromObj];
    }
    return object;
}

- (NSArray*)propertyKeys
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    free(properties);
    return keys;
}



- (NSArray *)getAllProperties
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        const char * attributes = property_getAttributes(properties[i]);//获取属性类型
        NSDictionary *dict = @{@"name":[NSString stringWithUTF8String:propertyName],@"attribute":[NSString stringWithUTF8String:attributes]};
        //        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
        [propertiesArray addObject:dict];
    }
    free(properties);
    return propertiesArray;
}

- (BOOL)autoPaddingParamsValues:(NSObject*)dataSource
{
    BOOL ret = NO;
    for (NSDictionary *dict in [self getAllProperties]) {
        NSString *key = [dict objectForKey:@"name"];
        NSString *attribute = [dict objectForKey:@"attribute"];
        if ([dataSource isKindOfClass:[NSDictionary class]]) {
            ret =
            ([dataSource valueForKey:key]==nil)?NO:YES;
        }
        else
        {
            ret = [dataSource respondsToSelector:NSSelectorFromString(key)];
        }
        if (ret) {
            id propertyValue = [dataSource valueForKey:key];
            if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {//是否是entitybase类
                NSString *className = [[[[attribute componentsSeparatedByString:@"T@\""] lastObject] componentsSeparatedByString:@"\""] firstObject];
                Class suberclass = NSClassFromString(className);
                Class superClass = [EntityBase class];
                if ([suberclass isSubclassOfClass:superClass]) {
                    EntityBase *base = (id)[[NSClassFromString(className) alloc] initResponseObjfromData:propertyValue];
                    
                    [self setValue:base forKey:key];
                }else
                    if ([propertyValue isKindOfClass:[NSArray class]] &&
                        [_arrayContainObjIsEntyBaseObjNeedToEncodeDict objectForKey:key]) {//是否是entitybase类集合
                        NSMutableArray *arr = [NSMutableArray array];
                        Class class = [_arrayContainObjIsEntyBaseObjNeedToEncodeDict objectForKey:key];
                        for (id data in propertyValue) {
                            EntityBase *base = (id)[class alloc];
                            [arr addObject:[base initResponseObjfromData:data]];
                        }
                        [self setValue:arr forKey:key];
                    }
                    else//正常nsobject类
                    {
                        NSObject *obj = nil;
                        NSRange range3 = [attribute rangeOfString:@"NSDecimalNumber"];
                        if (range3.length>0)
                        {
                            obj = [NSDecimalNumber decimalNumberWithString:[propertyValue stringValue]];
                            [self setValue:obj forKey:key];
                        }else
                            [self setValue:propertyValue forKey:key];
                    }
                
            }else
            {
                NSObject *obj = nil;
                NSRange range1 = [attribute rangeOfString:@"NSString"];
                NSRange range2  =[attribute rangeOfString:@"NSNumber"];
                NSRange range3 = [attribute rangeOfString:@"NSDecimalNumber"];
                NSRange range4 = [attribute rangeOfString:@"NSMutableArray"];
                NSRange range5 = [attribute rangeOfString:@"NSArray"];
                NSString *arrtibutename = nil;
                if (range1.length>0) {
                    arrtibutename = [attribute substringWithRange: range1];
                    obj = [[NSString  alloc] init];
                }else
                    if (range2.length>0) {
                        arrtibutename = [attribute substringWithRange: range2];
                        obj = [NSNumber numberWithInteger:0];
                    }else if (range3.length>0)
                    {
                        arrtibutename = [attribute substringWithRange: range3];
                        obj = [NSDecimalNumber decimalNumberWithString:@"0"];
                    }else if (range4.length>0)
                    {
                        arrtibutename = [attribute substringWithRange:range4];
                        obj = [NSMutableArray new];
                    }
                    else if (range5.length>0)
                    {
                        arrtibutename = [attribute substringWithRange:range5];
                        obj = [NSMutableArray new];
                    }else
                    {
                        NSString *className = [[[[attribute componentsSeparatedByString:@"T@\""] lastObject] componentsSeparatedByString:@"\""] firstObject];
                        Class suberclass = NSClassFromString(className);
                        Class superClass = [EntityBase class];
                        if ([suberclass isSubclassOfClass:superClass]) {
                            EntityBase *base = (id)[[NSClassFromString(className) alloc] init];
                            [self setValue:base forKey:key];
                        }
                    }
                if (arrtibutename) {
                    //                    [self setValue:obj forUndefinedKey:key];
                    [self setValue:obj forKey:key];
                }
            }
        }
    }
    return ret;
}

/*
 为解决a文件中包含b，b文件中包含a（a，b初始化时，所有字段都会初始化一个值）而设计的方法
 */
- (BOOL)manualPaddingParamsValues:(NSObject*)dataSource
{
    BOOL ret = NO;
    for (NSDictionary *dict in [self getAllProperties]) {
        
        NSString *key = [dict objectForKey:@"name"];
        NSString *attribute = [dict objectForKey:@"attribute"];
        
        if ([dataSource isKindOfClass:[NSDictionary class]]) {
            ret = ([dataSource valueForKey:key]==nil)?NO:YES;
        }
        else
        {
            ret = [dataSource respondsToSelector:NSSelectorFromString(key)];
        }
        if (ret) {
            
            id propertyValue = [dataSource valueForKey:key];
            
            //该值不为NSNULL，并且也不为nil
            
            if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {
                
                //                [self setValue:propertyValue forKey:key];
            }else
            {
                
                NSObject *obj = nil;
                NSRange range1 = [attribute rangeOfString:@"NSString"];
                NSRange range2  =[attribute rangeOfString:@"NSNumber"];
                NSRange range3 = [attribute rangeOfString:@"NSDecimalNumber"];
                NSRange range4 = [attribute rangeOfString:@"NSMutableArray"];
                NSRange range5 = [attribute rangeOfString:@"NSArray"];
                NSString *arrtibutename = nil;
                if (range1.length>0) {
                    arrtibutename = [attribute substringWithRange: range1];
                    obj = [[NSString  alloc] init];
                }else
                    if (range2.length>0) {
                        arrtibutename = [attribute substringWithRange: range2];
                        obj = [NSNumber numberWithInteger:0];
                    }else if (range3.length>0)
                    {
                        arrtibutename = [attribute substringWithRange: range3];
                        obj = [NSDecimalNumber decimalNumberWithString:@"0"];
                    }else if (range4.length>0)
                    {
                        arrtibutename = [attribute substringWithRange:range4];
                        obj = [NSMutableArray new];
                    }
                    else if (range5.length>0)
                    {
                        arrtibutename = [attribute substringWithRange:range5];
                        obj = [NSMutableArray new];
                    }
                if (arrtibutename) {
                    //                    [self setValue:obj forUndefinedKey:key];
                    [self setValue:obj forKey:key];
                    
                }
            }
        }
    }
    return ret;
}



#pragma mark -- copying

-(id)copyWithZone:(NSZone *)zone
{
    EntityBase *base = [[[self class]alloc] initResponseObjfromData:[self getRequsetDatafromObj]];
    return base;
}


#pragma mark -- coding
- (void)encodeWithCoder:(NSCoder*)coder
{
    for (NSDictionary *dict in [self getAllProperties]) {
        NSString *key = [dict objectForKey:@"name"];
        SEL getParamSel = NSSelectorFromString(key);
        id obj = [self performSelector:getParamSel];
        [coder encodeObject:obj forKey:key];
    }
    
}

- (id)initWithCoder:(NSCoder*)decoder
{
    if (self = [super init])
    {
        for (NSDictionary *dict in [self getAllProperties]) {
            NSString *key = [dict objectForKey:@"name"];
            [self setValue:[decoder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}

-(id)getRequestParmars
{
    return @{};
}
@end
