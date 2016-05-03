//
//  WeatherManager.m
//  WHWeather
//
//  Created by Wayne on 16/4/26.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "WeatherManager.h"
#import "WHWeatherGetData.h"
static WeatherManager *weatherManager;
@implementation WeatherManager

+(instancetype)sharedWeatherManager{
    if (!weatherManager) {
        weatherManager = [[WeatherManager alloc]init];
    }
    return weatherManager;
}
-(WeatherCityAqi*)getWeatherCityAqiWithDic:(NSDictionary*)dic{
    NSDictionary *dicAqi = dic[@"HeWeather data service 3.0"][0][@"aqi"][@"city"];
    WeatherCityAqi *aqi = [WeatherCityAqi new];
    
    [aqi setValuesForKeysWithDictionary:dicAqi];
    return aqi;
    
}
-(WeatherCityBasic*)getWeatherCityBasicWithDic:(NSDictionary*)dic{
    
    NSDictionary *dicBasic = dic[@"HeWeather data service 3.0"][0][@"basic"];
    WeatherCityBasic *basic = [WeatherCityBasic new];
    basic.city = dicBasic[@"city"];
    basic.country = dicBasic[@"cnty"];
    basic.cityID = dicBasic[@"id"];
    basic.latitude = dicBasic[@"lat"];
    basic.longitude = dicBasic[@"lon"];
    basic.updateLoc = dicBasic[@"update"][@"loc"];
    basic.updateUtc = dicBasic[@"update"][@"utc"];
    return basic;
    

}
-(NSArray*)getWeatherDailyForecastWithDic:(NSDictionary*)dic{
    NSArray *arr = dic[@"HeWeather data service 3.0"][0][@"daily_forecast"];
    NSMutableArray *mutaArr = [NSMutableArray array];
    for (NSDictionary *dicForecast in arr) {
        WeatherDailyForecast *dailyForecast = [WeatherDailyForecast new];
        [dailyForecast setValuesForKeysWithDictionary:dicForecast];
        [mutaArr addObject:dailyForecast];
    }
    return mutaArr;
}

-(NSArray*)getWeatherHourlyForecastWithDic:(NSDictionary*)dic{
    NSArray *arr = dic[@"HeWeather data service 3.0"][0][@"hourly_forecast"];
    NSMutableArray *mutaArr = [NSMutableArray array];
    for (NSDictionary *dicForecast in arr) {
        WeatherHourlyForecast *hourlyForecast = [WeatherHourlyForecast new];
        [hourlyForecast setValuesForKeysWithDictionary:dicForecast];
        [mutaArr addObject:hourlyForecast];
    }
    return mutaArr;
}

-(WeatherNow*)getWeatherNowWithDic:(NSDictionary*)dic{
    NSDictionary *dicNow = dic[@"HeWeather data service 3.0"][0][@"now"];
    WeatherNow *now = [WeatherNow new];
    
    [now setValuesForKeysWithDictionary:dicNow];
    return now;
}

-(WeatherSuggestion*)getWeatherSuggestionWithDic:(NSDictionary*)dic{
    NSDictionary *dicSuggestion = dic[@"HeWeather data service 3.0"][0][@"suggestion"];
    WeatherSuggestion *suggestion = [WeatherSuggestion new];
    
    [suggestion setValuesForKeysWithDictionary:dicSuggestion];
    return suggestion;
}

@end
