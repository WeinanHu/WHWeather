//
//  RESideMenuViewController.m
//  WHWeather
//
//  Created by Wayne on 16/4/25.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "RESideMenuViewController.h"
#import "LeftTableViewController.h"
#import "MainTableViewController.h"
@interface RESideMenuViewController ()<RESideMenuDelegate>

@end

@implementation RESideMenuViewController
- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    UINavigationController *naviController = (UINavigationController*)self.contentViewController;
    
    naviController.viewControllers.firstObject.view.backgroundColor = [UIColor clearColor];
    
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    self.leftMenuViewController.view.backgroundColor = [UIColor clearColor];
//    LeftTableViewController *leftController = (LeftTableViewController*)self.leftMenuViewController;
//    leftController.tableView.contentInset = UIEdgeInsetsMake((SCREEN_HEIGHT-ROW_HEIGHT*leftController.leftMenus.count)/2, 0, 0, 0);
//    self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];
    
    self.backgroundImage = [UIImage imageNamed:@"Stars"];
    self.contentViewShadowEnabled = YES;


    self.contentViewShadowColor = [UIColor blackColor];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController{
    [UIView animateWithDuration:0.3 animations:^{
        ((MainTableViewController*)((UINavigationController*)self.contentViewController).viewControllers.firstObject).tableView.backgroundView.alpha = 1;
    }];
}
-(void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController{
    
}
-(void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController{
    [UIView animateWithDuration:0.3 animations:^{
        ((MainTableViewController*)((UINavigationController*)self.contentViewController).viewControllers.firstObject).tableView.backgroundView.alpha = 0;
    }];
}
@end
