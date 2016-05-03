//
//  WeatherSuggestion.h
//  WHWeather
//
//  Created by Wayne on 16/4/26.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherSuggestion : NSObject
@property(nonatomic,strong) NSDictionary *comf;
@property(nonatomic,strong) NSDictionary *cw;
@property(nonatomic,strong) NSDictionary *drsg;
@property(nonatomic,strong) NSDictionary *flu;
@property(nonatomic,strong) NSDictionary *sport;
@property(nonatomic,strong) NSDictionary *trav;
@property(nonatomic,strong) NSDictionary *uv;

@end
