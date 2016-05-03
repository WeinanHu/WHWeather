//
//  DailyTableViewCell.m
//  WHWeather
//
//  Created by Wayne on 16/4/27.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "DailyTableViewCell.h"

@implementation DailyTableViewCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    //change frame to all platform
    self.dailyDayImageView.frame = [self changeRectToAllPlatform:self.dailyDayImageView];
    UIView *dayView = [[UIView alloc]initWithFrame:self.dailyDayImageView.frame];
    dayView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.728];
    dayView.layer.cornerRadius = dayView.frame.size.height/2;
    
    dayView.layer.masksToBounds = YES;
    [self insertSubview:dayView atIndex:0];
    
    

    
    self.dailyNightImageView.frame = [self changeRectToAllPlatform:self.dailyNightImageView];
    UIView *nightView = [[UIView alloc]initWithFrame:self.dailyNightImageView.frame];
    nightView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.728];
    nightView.layer.cornerRadius = nightView.frame.size.height/2;
    
    nightView.layer.masksToBounds = YES;
    [self insertSubview:nightView atIndex:0];
    
    
    self.dailyDayCondLabel.frame = [self changeRectToAllPlatform:self.dailyDayCondLabel];
    self.dailyNightCondLabel.frame = [self changeRectToAllPlatform:self.dailyNightCondLabel];
    self.dailyTmpAndWindLabel.frame = [self changeRectToAllPlatform:self.dailyTmpAndWindLabel];
    self.dailyDateLabel.frame = [self changeRectToAllPlatform:self.dailyDateLabel];
}
-(CGRect)changeRectToAllPlatform:(UIView*)view{
    
    CGRect frame = view.frame;
    if ([view isKindOfClass:[UIImageView class]]) {
        return CGRectMake(frame.origin.x*SCREEN_WIDTH/320.0, frame.origin.y*SCREEN_HEIGHT/568.0, frame.size.width*SCREEN_HEIGHT/568.0, frame.size.height*SCREEN_HEIGHT/568.0);
    }else{
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel*)view;
            label.font = [UIFont systemFontOfSize:label.font.pointSize*SCREEN_HEIGHT/568.0];
            
        }else if([view isKindOfClass:[UIButton class]]){
            UIButton *button = (UIButton*)view;
            button.titleLabel.font = [UIFont systemFontOfSize:button.titleLabel.font.pointSize*SCREEN_HEIGHT/568.0];
            
        }
        
        return CGRectMake(frame.origin.x*SCREEN_WIDTH/320.0, frame.origin.y*SCREEN_HEIGHT/568.0, frame.size.width*SCREEN_WIDTH/320.0, frame.size.height*SCREEN_HEIGHT/568.0);
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
