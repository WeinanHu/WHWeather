//
//  HourlyTableViewCell.m
//  WHWeather
//
//  Created by Wayne on 16/4/27.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "HourlyTableViewCell.h"

@implementation HourlyTableViewCell

-(void)awakeFromNib{
    self.backgroundColor = [UIColor clearColor];
    //change frame to all platform
    self.hourlyHumLabel.frame = [self changeRectToAllPlatform:self.hourlyHumLabel];
    self.hourlyTimeLabel.frame = [self changeRectToAllPlatform:self.hourlyTimeLabel];
    self.hourlyTmpLabel.frame = [self changeRectToAllPlatform:self.hourlyTmpLabel];
    self.hourlyWindLabel.frame = [self changeRectToAllPlatform:self.hourlyWindLabel];
    
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
