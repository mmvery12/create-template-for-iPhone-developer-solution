//
//  FileManager.h
//  Template
//
//  Created by liyuchang on 15/10/15.
//  Copyright (c) 2015年 liyuchang. All rights reserved.
//


#import <Foundation/Foundation.h>
#define docDir  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define cachesDir  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define temoDir  NSTemporaryDirectory()

typedef NS_ENUM(NSInteger, FilePathType) {
    DocumentPath,
    TempPath,
    CachePath
};

@interface FileManager : NSObject
+(NSString *)CreateFileWithName:(NSString *)name path:(FilePathType)pathType data:(NSData *)data;
+(void)RemoveFileWithName:(NSString *)name path:(FilePathType)pathtye;
+(id)fileWithName:(NSString *)name path:(FilePathType)pathtype;
@end
