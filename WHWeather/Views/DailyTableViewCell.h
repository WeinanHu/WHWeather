//
//  DailyTableViewCell.h
//  WHWeather
//
//  Created by Wayne on 16/4/27.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *dailyDayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *dailyNightImageView;
@property (weak, nonatomic) IBOutlet UILabel *dailyDayCondLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyNightCondLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyTmpAndWindLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyDateLabel;

@end
