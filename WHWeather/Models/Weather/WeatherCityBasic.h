//
//  WeatherCityBasic.h
//  WHWeather
//
//  Created by Wayne on 16/4/26.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherCityBasic : NSObject
@property(nonatomic,strong) NSString *city;
@property(nonatomic,strong) NSString *country;
@property(nonatomic,strong) NSString *cityID;
@property(nonatomic,strong) NSString *latitude;
@property(nonatomic,strong) NSString *longitude;
@property(nonatomic,strong) NSString *updateLoc;
@property(nonatomic,strong) NSString *updateUtc;
@end
