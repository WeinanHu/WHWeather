//
//  WeatherHourlyForecast.h
//  WHWeather
//
//  Created by Wayne on 16/4/26.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherHourlyForecast : NSObject
@property(nonatomic,strong) NSString *date;
@property(nonatomic,strong) NSString *hum;
@property(nonatomic,strong) NSString *pop;
@property(nonatomic,strong) NSString *pres;
@property(nonatomic,strong) NSString *tmp;
@property(nonatomic,strong) NSDictionary *wind;

@end
