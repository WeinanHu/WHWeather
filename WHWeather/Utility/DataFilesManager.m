//
//  DataFilesManager.m
//  WHWeather
//
//  Created by Wayne on 16/4/28.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "DataFilesManager.h"

@implementation DataFilesManager
+(void)historyCitySaveWithDic:(NSDictionary *)dic compareKey:(NSString*)keyStr{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"history.plist"];
    if (!filePath) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    NSArray *arrForFile = [NSArray arrayWithContentsOfFile:filePath];
    if (!arrForFile) {
        arrForFile = [NSArray array];
    }
    for (NSDictionary *dicIn in arrForFile) {
        if ([dicIn[keyStr] isEqualToString:dic[keyStr]]) {
            return;
        }
    }
    NSArray *arrForWrite = [arrForFile arrayByAddingObject:dic];
    [arrForWrite writeToFile:filePath atomically:YES];
    
}
@end
