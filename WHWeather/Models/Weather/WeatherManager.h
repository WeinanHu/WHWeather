//
//  WeatherManager.h
//  WHWeather
//
//  Created by Wayne on 16/4/26.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherCityAqi.h"
#import "WeatherCityBasic.h"
#import "WeatherDailyForecast.h"
#import "WeatherHourlyForecast.h"
#import "WeatherNow.h"
#import "WeatherSuggestion.h"
@interface WeatherManager : NSObject
+(instancetype)sharedWeatherManager;
-(WeatherCityAqi*)getWeatherCityAqiWithDic:(NSDictionary*)dic;
-(WeatherCityBasic*)getWeatherCityBasicWithDic:(NSDictionary*)dic;
-(NSArray*)getWeatherDailyForecastWithDic:(NSDictionary*)dic;
-(NSArray*)getWeatherHourlyForecastWithDic:(NSDictionary*)dic;
-(WeatherNow*)getWeatherNowWithDic:(NSDictionary*)dic;
-(WeatherSuggestion*)getWeatherSuggestionWithDic:(NSDictionary*)dic;

@end
