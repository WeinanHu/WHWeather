//
//  WHWeatherGetData.h
//  WHWeather
//
//  Created by Wayne on 16/4/25.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^BLOCK_GET_WEATHER)(NSDictionary* dic,NSError* err);

@interface WHWeatherGetData : NSObject

@property(nonatomic,strong) NSArray *sortedCities;
@property(nonatomic,strong) NSArray *sortedAttractions;

+(void)weatherWithCity:(NSString*)searchID completionBlock:(BLOCK_GET_WEATHER)weatherBlock;
+(void)searchAllChina;
+(void)searchAllAttractions;
+(void)searchAllCondition;
@end



