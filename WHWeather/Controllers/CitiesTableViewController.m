//
//  CitiesTableViewController.m
//  WHWeather
//
//  Created by Wayne on 16/4/26.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "CitiesTableViewController.h"
#import "AllCitiesManager.h"
#import "DataFilesManager.h"
@interface CitiesTableViewController ()<UISearchBarDelegate>
@property(nonatomic,strong) NSArray *cities;
@property(nonatomic,strong) NSArray *citiesTitle;
@property(nonatomic,strong) UISearchBar *searchBar;
@end

@implementation CitiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-240-20, 6, 240, 30)];
    self.searchBar.delegate = self;
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backBarButtonClicked)];
    barButton.tintColor = [UIColor colorWithWhite:0.856 alpha:1.000];
    self.navigationItem.leftBarButtonItem = barButton;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor colorWithWhite:0.911 alpha:1.000];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.701]];
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Stars"]];
    self.tableView.bounces = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)backBarButtonClicked{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cities.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ((NSArray*)self.cities[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityInfoCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CityInfoCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:cell.textLabel.font.pointSize*SCREEN_HEIGHT/568.0];
        cell.textLabel.textColor = [UIColor colorWithRed:0.797 green:0.841 blue:0.841 alpha:0.952];
        cell.detailTextLabel.text = @"";
        cell.backgroundColor = [UIColor clearColor];
    }
    NSArray *arr = self.cities[indexPath.section];
    WHWeatherCityInfo *cityInfo = arr[indexPath.row];
    cell.textLabel.text = cityInfo.city;
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    WHWeatherCityInfo *cityInfo = ((NSArray*)self.cities[section])[0];
    return cityInfo.province;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
    UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-24, 25)];
    subView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-44, 25)];
    WHWeatherCityInfo *cityInfo = ((NSArray*)self.cities[section])[0];
    label.textColor = [UIColor blackColor];
    label.text = cityInfo.province;
    label.font = [UIFont boldSystemFontOfSize:label.font.pointSize];
    [subView addSubview:label];
    [view addSubview:subView];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.citiesTitle;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WHWeatherCityInfo *cityInfo = self.cities[indexPath.section][indexPath.row];
    [self saveCityID:cityInfo.cityID cityName:cityInfo.city];
    self.block(cityInfo);
    [self dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.sideMenu hideMenuViewController];
        });
    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0*SCREEN_HEIGHT/568;
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self addCoverView];
    return YES;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self findCityWithString:searchBar.text block:^(WHWeatherCityInfo *cityInfo, NSIndexPath *indexPath) {
        if (cityInfo) {
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }];
    
}
-(void)findCityWithString:(NSString*)str block:(void(^)(WHWeatherCityInfo* cityInfo,NSIndexPath *indexPath))block{
    
    for (int i = 0;i < self.cities.count;i++) {
        NSArray* arr = self.cities[i];
        for (int j = 0; j < arr.count; j++) {
            WHWeatherCityInfo *cityInfo = arr[j];
            if ([cityInfo.city containsString:str]||[cityInfo.province containsString:str]) {
                if (block) {
                    block(cityInfo,[NSIndexPath indexPathForRow:j inSection:i]);
                }
                return;
            }
        }
    }

    
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}


static UIWindow *window;
-(void)addCoverView{
    
    window = [[UIWindow alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    window.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.498];

    window.hidden = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];

    [window addGestureRecognizer:tap];
}
-(void)tapCover:(UITapGestureRecognizer*)sender{
    [self.navigationController.navigationBar endEditing:YES];
    window.hidden = YES;
}
-(void)dealloc{
    window=nil;
}

-(void)saveCityID:(NSString*)cityID cityName:(NSString*)city{
    NSDictionary *dic = @{@"city":city,@"cityID":cityID};
    [DataFilesManager historyCitySaveWithDic:dic compareKey:@"cityID"];
    
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

-(NSArray*)cities {
	if(_cities == nil) {
        
		_cities = [[AllCitiesManager sharedAllCitiesManager]allCities];
        NSMutableArray *citySections = [NSMutableArray array];
        NSMutableArray *selfCities = [NSMutableArray arrayWithArray:_cities];
        while (selfCities.count) {
            WHWeatherCityInfo *cityInfo = selfCities[0];
            NSMutableArray *tmpArr = [NSMutableArray array];
            for (WHWeatherCityInfo *cityInfoTmp in selfCities) {                    if([[cityInfo.province substringToIndex:2]isEqualToString:[cityInfoTmp.province substringToIndex:2]]){
                [tmpArr addObject:cityInfoTmp];
                
            }
            }
            //delete
                for (WHWeatherCityInfo *cityForDelete in tmpArr) {
                    [selfCities removeObject:cityForDelete];
                }
            
            [citySections addObject:tmpArr];
            
        }
        
        _cities = citySections;
	}
	return _cities;
}

- (NSArray *)citiesTitle {
	if(_citiesTitle == nil) {
        NSMutableArray *mutaArr = [NSMutableArray array];
        for (NSArray *arr in self.cities) {
            WHWeatherCityInfo *cityInfo = arr[0];
            NSString *str = [cityInfo.province substringToIndex:2];
            [mutaArr addObject:str];
        }
		_citiesTitle = mutaArr;
	}
	return _citiesTitle;
}

@end
