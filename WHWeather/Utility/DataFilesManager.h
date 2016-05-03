//
//  DataFilesManager.h
//  WHWeather
//
//  Created by Wayne on 16/4/28.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataFilesManager : NSObject
+(void)historyCitySaveWithDic:(NSDictionary *)dic compareKey:(NSString*)keyStr;
@end
