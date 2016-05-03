//
//  MainHeaderView.m
//  WHWeather
//
//  Created by Wayne on 16/4/26.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "MainHeaderView.h"
@interface MainHeaderView()


@end
@implementation MainHeaderView
- (IBAction)detailButtonClicked:(id)sender {
    
}
-(void)awakeFromNib{
    self.backgroundColor = [UIColor clearColor];
    //change frame to all platform
    self.weatherIcon.frame = [self changeRectToAllPlatform:self.weatherIcon];
    self.weatherCondLabel.frame = [self changeRectToAllPlatform:self.weatherCondLabel];
    self.weatherTmpLabel.frame = [self changeRectToAllPlatform:self.weatherTmpLabel];
    self.cityLabel.frame = [self changeRectToAllPlatform:self.cityLabel];
    
    self.weatherHumLabel.frame = [self changeRectToAllPlatform:self.weatherHumLabel];
    self.detailWeatherButton.frame = [self changeRectToAllPlatform:self.detailWeatherButton];
    self.weatherWindDirectionLabel.frame = [self changeRectToAllPlatform:self.weatherWindDirectionLabel];
    self.weatherWindScaleLabel.frame = [self changeRectToAllPlatform:self.weatherWindScaleLabel];
    
    UIView *viewIcon = [[UIView alloc]initWithFrame:self.weatherIcon.frame];
    viewIcon.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.728];
    viewIcon.layer.cornerRadius = 20;
    
    viewIcon.layer.masksToBounds = YES;
    
    [self insertSubview:viewIcon belowSubview:self.weatherIcon];
    
    //detailButton
    UIView *detailView = [[UIView alloc]initWithFrame:self.detailWeatherButton.frame];
    detailView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.728];
    detailView.layer.cornerRadius = detailView.frame.size.height/2;
    
    detailView.layer.masksToBounds = YES;
    [self insertSubview:detailView belowSubview:self.detailWeatherButton];
    
    
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
