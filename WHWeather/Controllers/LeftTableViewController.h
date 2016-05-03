//
//  LeftTableViewController.h
//  WHWeather
//
//  Created by Wayne on 16/4/25.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ROW_HEIGHT 55
@interface LeftTableViewController : UIViewController
@property(nonatomic,strong) NSArray *leftMenus;
@property(nonatomic,strong) NSArray *menuImages;
@property(nonatomic,strong) UITableView *tableView;

@end
