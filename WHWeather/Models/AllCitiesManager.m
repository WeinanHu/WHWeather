//
//  AllCitiesManager.m
//  WHWeather
//
//  Created by Wayne on 16/4/26.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "AllCitiesManager.h"
static AllCitiesManager *allCitiesManager;
@implementation AllCitiesManager
-(NSArray *)allCities{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"allchina.plist" ofType:nil];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *mutaArr = [NSMutableArray array];

    for (NSDictionary *dic in arr) {
        WHWeatherCityInfo *cityInfo = [WHWeatherCityInfo new];
        cityInfo.city = dic[@"city"];
        cityInfo.country = dic[@"cnty"];
        cityInfo.cityID = dic[@"id"];
        cityInfo.latitude = dic[@"lat"];
        cityInfo.longitude = dic[@"lon"];
//        cityInfo.pinyin = dic[@"pinyin"];
        cityInfo.province = dic[@"prov"];
        [mutaArr addObject:cityInfo];
    }
    return mutaArr;
}
+(instancetype)sharedAllCitiesManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!allCitiesManager) {
            allCitiesManager = [AllCitiesManager new];
        }
    });
    
    return allCitiesManager;
}
@end
