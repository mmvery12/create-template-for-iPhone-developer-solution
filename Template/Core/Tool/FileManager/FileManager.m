//
//  FileManager.m
//  Template
//
//  Created by liyuchang on 15/10/15.
//  Copyright (c) 2015年 liyuchang. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager
+(NSString *)CreateFileWithName:(NSString *)name path:(FilePathType)path data:(NSData *)data
{
//    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    
//    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    
//    NSString *temoDir = NSTemporaryDirectory();
    
    if (!data) {
        return nil;
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
    NSString *xx = nil;
    if ([writepath hasSuffix:@"/"]) {
        xx = [writepath stringByAppendingString:name];
    }else
        xx = [writepath stringByAppendingPathComponent:name];
    if ([data writeToFile:xx atomically:YES]) {
        return xx;
    }
    return nil;
}
+(void)RemoveFileWithName:(NSString *)name path:(FilePathType)pathtye;
{
    
    NSString *writepath = nil;
    switch (pathtye) {
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
    NSString *xx = nil;
    if ([writepath hasSuffix:@"/"]) {
        xx = [writepath stringByAppendingString:name];
    }else
        xx = [writepath stringByAppendingPathComponent:name];
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:xx error:&error];
}
+(id)fileWithName:(NSString *)name path:(FilePathType)path;
{
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
    NSString *xx = nil;
    if ([writepath hasSuffix:@"/"]) {
        xx = [writepath stringByAppendingString:name];
    }else
        xx = [writepath stringByAppendingPathComponent:name];
    return [NSData dataWithContentsOfFile:xx];
}
@end
