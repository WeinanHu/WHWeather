//
//  AllCitiesManager.h
//  WHWeather
//
//  Created by Wayne on 16/4/26.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHWeatherCityInfo.h"
@interface AllCitiesManager : NSObject
-(NSArray*)allCities;
+(instancetype)sharedAllCitiesManager;
@end
