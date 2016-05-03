//
//  MainHeaderView.h
//  WHWeather
//
//  Created by Wayne on 16/4/26.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *weatherCondLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherTmpLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherHumLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailWeatherButton;
@property (weak, nonatomic) IBOutlet UILabel *weatherWindDirectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherWindScaleLabel;

@end
