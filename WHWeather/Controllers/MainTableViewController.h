//
//  MainTableViewController.h
//  WHWeather
//
//  Created by Wayne on 16/4/25.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHWeatherCityInfo.h"
@interface MainTableViewController : UITableViewController
@property(nonatomic,strong) WHWeatherCityInfo *cityInfo;
-(void)sendRequestForWeatherWithCity:(WHWeatherCityInfo*)cityInfo;
@end
