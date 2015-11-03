//
//  FileManager.h
//  Template
//
//  Created by liyuchang on 15/10/15.
//  Copyright (c) 2015年 liyuchang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FilePath) {
    DocumentPath,
    TempPath,
    CachePath
};

@interface FileManager : NSObject
+(BOOL)CreateFileWithName:(NSString *)name path:(FilePath)path data:(NSData *)data;
@end
