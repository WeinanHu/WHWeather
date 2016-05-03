//
//  HourlyTableViewCell.h
//  WHWeather
//
//  Created by Wayne on 16/4/27.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HourlyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hourlyWindLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourlyHumLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourlyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourlyTmpLabel;

@end
