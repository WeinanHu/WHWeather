//
//  WeatherNow.h
//  WHWeather
//
//  Created by Wayne on 16/4/26.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherNow : NSObject
@property(nonatomic,strong) NSDictionary *cond;
@property(nonatomic,strong) NSString *fl;
@property(nonatomic,strong) NSString *hum;
@property(nonatomic,strong) NSString *pcpn;
@property(nonatomic,strong) NSString *pres;
@property(nonatomic,strong) NSString *tmp;
@property(nonatomic,strong) NSString *vis;
@property(nonatomic,strong) NSDictionary *wind;
@end
