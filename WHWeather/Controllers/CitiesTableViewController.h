//
//  CitiesTableViewController.h
//  WHWeather
//
//  Created by Wayne on 16/4/26.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHWeatherCityInfo.h"
#import "RESideMenuViewController.h"
typedef void(^BLOCK)(WHWeatherCityInfo* cityInfo);
@interface CitiesTableViewController : UITableViewController
@property(nonatomic,strong) BLOCK block;
@property(nonatomic,strong) RESideMenuViewController *sideMenu;
@end
