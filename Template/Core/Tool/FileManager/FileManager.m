//
//  FileManager.m
//  Template
//
//  Created by liyuchang on 15/10/15.
//  Copyright (c) 2015年 liyuchang. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager
+(BOOL)CreateFileWithName:(NSString *)name path:(FilePath)path data:(NSData *)data
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths2 objectAtIndex:0];
    
    NSString *temoDir = NSTemporaryDirectory();
    
    if (!data) {
        return NO;
    }
    NSString *writepath = nil;
    switch (path) {
        case DocumentPath:
            writepath = docDir;
            break;
        case TempPath:
            writepath = temoDir;
            break;
        case CachePath:
            writepath = cachesDir;
            break;
        default:
            break;
    }
    
    return [data writeToFile:[writepath stringByAppendingPathComponent:name] atomically:YES];
}
@end
