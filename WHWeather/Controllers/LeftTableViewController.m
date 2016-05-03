//
//  LeftTableViewController.m
//  WHWeather
//
//  Created by Wayne on 16/4/25.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "LeftTableViewController.h"
//#import <Foundation/Foundation.h>
#import "CitiesTableViewController.h"
#import "RESideMenuViewController.h"
#import "MainTableViewController.h"
@interface LeftTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LeftTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.tableView attribute:NSLayoutAttributeLeft multiplier:1 constant:40];
//    [self.tableView addConstraint:constraint];
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(20*SCREEN_WIDTH/320, (SCREEN_HEIGHT-ROW_HEIGHT*SCREEN_HEIGHT/568.0*self.leftMenus.count)/2, 197*SCREEN_WIDTH/320, ROW_HEIGHT*SCREEN_HEIGHT/568.0*self.leftMenus.count) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.leftMenus.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LeftCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:cell.textLabel.font.pointSize/44.0*ROW_HEIGHT*SCREEN_HEIGHT/568];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.imageView.image = [UIImage imageNamed:self.menuImages[indexPath.row]];
        
    }
    cell.textLabel.text = self.leftMenus[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        CitiesTableViewController *cv = [CitiesTableViewController new];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:cv];
        cv.sideMenu = (RESideMenuViewController*)self.parentViewController;
        cv.block = ^(WHWeatherCityInfo* cityInfo){
            RESideMenuViewController *smv = (RESideMenuViewController*)self.parentViewController;
            UINavigationController *navi = (UINavigationController*)smv.contentViewController;
            MainTableViewController *main = (MainTableViewController*)navi.viewControllers.firstObject;
            main.cityInfo = cityInfo;
            [main sendRequestForWeatherWithCity:cityInfo];
        };
        
        [self presentViewController:navi animated:YES completion:nil];
        
    }else{
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ROW_HEIGHT*SCREEN_HEIGHT/568.0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSArray *)leftMenus {
	if(_leftMenus == nil) {
        _leftMenus = @[@"城市",@"历史使用地点"];
	}
	return _leftMenus;
}
-(NSArray *)menuImages{
    if (_menuImages == nil) {
        _menuImages = @[@"GLOBE",@"BOOKMARK"];
    }
    return _menuImages;
}
@end
