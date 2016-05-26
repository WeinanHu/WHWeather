//
//  MainTableViewController.m
//  WHWeather
//
//  Created by Wayne on 16/4/25.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "MainTableViewController.h"
#import "WHWeatherGetData.h"
#import "RESideMenuViewController.h"
#import "MainHeaderView.h"
#import "WeatherManager.h"
#import "AllCitiesManager.h"

#import "HourlyTableViewCell.h"
#import "DailyTableViewCell.h"

#import <math.h>
#import <CoreLocation/CoreLocation.h>
@interface MainTableViewController ()<CLLocationManagerDelegate>
@property(nonatomic,strong) WeatherCityAqi *weatherCityApi;
@property(nonatomic,strong) WeatherCityBasic *weatherCityBasic;
@property(nonatomic,strong) NSArray *weatherDailyForecast;
@property(nonatomic,strong) NSArray *weatherHourlyForecast;
@property(nonatomic,strong) WeatherNow *weatherNow;
@property(nonatomic,strong) WeatherSuggestion *weatherSuggestion;

@property(nonatomic,strong) MainHeaderView *mainHeaderView;
@property(nonatomic,strong) CLLocationManager *clManager;
@property(nonatomic,assign) double latitude;
@property(nonatomic,assign) double longitude;

@end

@implementation MainTableViewController
#pragma mark - 请求服务器数据
-(void)sendRequestForWeatherWithCity:(WHWeatherCityInfo*)cityInfo{
    NSString *searchID = [NSString stringWithFormat:@"weather?cityid=%@",cityInfo.cityID];
    [WHWeatherGetData weatherWithCity:searchID completionBlock:^(NSDictionary *dic, NSError *err) {
        self.weatherCityApi = [[WeatherManager sharedWeatherManager]getWeatherCityAqiWithDic:dic];
        self.weatherCityBasic = [[WeatherManager sharedWeatherManager]getWeatherCityBasicWithDic:dic];
        self.weatherDailyForecast = [[WeatherManager sharedWeatherManager]getWeatherDailyForecastWithDic:dic];
        self.weatherHourlyForecast = [[WeatherManager sharedWeatherManager]getWeatherHourlyForecastWithDic:dic];
        self.weatherNow = [[WeatherManager sharedWeatherManager]getWeatherNowWithDic:dic];
        self.weatherSuggestion = [[WeatherManager sharedWeatherManager]getWeatherSuggestionWithDic:dic];
//        NSLog(@"%@,%@,%@,%@,%@,%@",self.weatherCityApi,self.weatherCityBasic,self.weatherDailyForecast,self.weatherHourlyForecast,self.weatherNow,self.weatherSuggestion);
//        NSLog(@"%@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
    }];
}
#pragma mark - 更新section0 headerView
-(void)refreshMainWeatherInfo{
    //section0 header
    NSLog(@"-----------%@",self.weatherNow.cond[@"txt"]);
    NSString *condTxt = [self changeStringIfNull:self.weatherNow.cond[@"txt"]];
    NSString *city = [self changeStringIfNull:self.weatherCityBasic.city];
    NSString *tmp = [self changeStringIfNull:self.weatherNow.tmp];
    NSString *fl = [self changeStringIfNull:self.weatherNow.fl];
    NSString *hum = [self changeStringIfNull:self.weatherNow.hum];
    NSString *dir = [self changeStringIfNull:self.self.weatherNow.wind[@"dir"]];
    NSString *sc = [self changeStringIfNull:self.weatherNow.wind[@"sc"]];
    
    
    self.mainHeaderView.weatherIcon.image = [UIImage imageNamed:self.weatherNow.cond[@"code"]];
    self.mainHeaderView.weatherCondLabel.text = [NSString stringWithFormat:@"%@",condTxt];
    
    self.mainHeaderView.cityLabel.text = city;
    
    self.mainHeaderView.weatherTmpLabel.text = [NSString stringWithFormat:@"%@℃/%@℃",tmp,fl];
    self.mainHeaderView.weatherHumLabel.text = [NSString stringWithFormat:@"相对湿度:%@°",hum];
    self.mainHeaderView.weatherWindDirectionLabel.text = [NSString stringWithFormat:@"风向:%@",dir];
    NSString *tmpStr = [[NSString alloc]init];
    if ([sc isEqualToString:@"微风"]||self.weatherNow.wind[@"sc"]==nil || [sc isEqualToString:@"..."]) {
        tmpStr = @"";
    }else{
        tmpStr = @"级";
    }
    self.mainHeaderView.weatherWindScaleLabel.text = [NSString stringWithFormat:@"%@ %@",sc,tmpStr];
    
//    NSLog(@"%@,%@",self.mainHeaderView.weatherCondLabel.text,self.mainHeaderView.weatherTmpLabel.text);
   
}
#pragma mark - 转换null字符串成loading
-(NSString*)changeStringIfNull:(NSString*)str{
    if (!str) {
        str = @"...";
        
    }
   
    return str;
}
#pragma mark - 获取用户位置
-(void)getUserLocation{
    self.clManager = [CLLocationManager new];
    if ([[UIDevice currentDevice].systemVersion doubleValue]>=8.0) {
        //征求用户的同意
        [self.clManager requestWhenInUseAuthorization];
    }else{
        //iOS<8.0,直接定位的方法
        [self.clManager startUpdatingLocation];
    }
    self.clManager.delegate = self;
    
}
#pragma mark - 获取用户位置的代理
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            //设置用户的distanceFilter(减少定位方法调用次数)
            self.clManager.distanceFilter = 1000;
            //用户同意前台定位,开始定位
            [self.clManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied:
            break;
            
        default:
            break;
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //获取locations数组中的最后一个对象（最新的位置）
    CLLocation *recentLocation = [locations lastObject];
    //打印用户的经纬度
//    NSLog(@"%@",recentLocation);
    NSLog(@"纬度%f;经度%f",recentLocation.coordinate.latitude,recentLocation.coordinate.longitude);
    
    WHWeatherCityInfo *cityInfo = [self findNearestWeatherInfoWithLatitude:recentLocation.coordinate.latitude longitude:recentLocation.coordinate.longitude];
    [self sendRequestForWeatherWithCity:cityInfo];
    
    [self.clManager stopUpdatingLocation];
    self.clManager = nil;
}
#pragma mark - 查找最近位置
-(WHWeatherCityInfo*)findNearestWeatherInfoWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    NSArray *arrCity = [[AllCitiesManager sharedAllCitiesManager] allCities];
    NSMutableArray *mutaArr = [NSMutableArray array];
    for (int i = 0; i < arrCity.count; i++){
        WHWeatherCityInfo *cityInfo = arrCity[i];
        float lat = [cityInfo.latitude floatValue];
        float lon = [cityInfo.longitude floatValue];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:[NSNumber numberWithInt:i] forKey:@"number"];
        double distance = [self getDistanceWithLatA:latitude lonA:longitude latB:lat lonB:lon];
        [dic setValue:[NSNumber numberWithFloat:distance] forKey:@"distance"];
        
        [mutaArr addObject:dic];
    }
//    NSLog(@"%@",mutaArr);
    //compare
    NSDictionary *minDic = mutaArr[0];
    for (int i = 0 ; i<mutaArr.count-1; i++) {
        float j = [mutaArr[i+1][@"distance"] floatValue];
        float min = [minDic[@"distance"] floatValue];
        if (min>j) {
            minDic = mutaArr[i+1];
        }
    }
    int index = [minDic[@"number"] intValue];
//    NSLog(@"__________________®index%d",index);
    return arrCity[index];
}
-(double)getDistanceWithLatA:(float)latA lonA:(float)lonA latB:(float)latB lonB:(float)lonB{
//    latA = latA*M_PI/180;
//    latB = latB*M_PI/180;
//    lonA = lonA*M_PI/180;
//    lonB = lonB*M_PI/180;
//    double sqrtNum = pow( sin((latA-latB)/2),2)  +  cos(latA) * cos(latB) +  pow(sin((lonA-lonB)/2),2);
//    
//    double distance = 2*asin(sqrt(sqrtNum ) )*6378.137;
//    return distance;
    return pow((latA-latB),2)+pow((lonA-lonB)*cos(lonA), 2);
}

#pragma mark - 点击设置按钮
-(void)leftButtonClicked{
    RESideMenuViewController *sideController = (RESideMenuViewController*)self.parentViewController.parentViewController;
    sideController.contentViewShadowEnabled = YES;
    
    [sideController presentLeftMenuViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    //偏移效果
    UIInterpolatingMotionEffect * xEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xEffect.minimumRelativeValue =  [NSNumber numberWithFloat:-15.0];
    xEffect.maximumRelativeValue = [NSNumber numberWithFloat:15.0];
    [self.view addMotionEffect:xEffect];
    UIInterpolatingMotionEffect * yEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yEffect.minimumRelativeValue =  [NSNumber numberWithFloat:-15.0];
    yEffect.maximumRelativeValue = [NSNumber numberWithFloat:15.0];
    [self.view addMotionEffect:yEffect];
//        [WHWeatherGetData searchAllChina];
//        [WHWeatherGetData searchAllAttractions];
//        [WHWeatherGetData searchAllCondition];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self getUserLocation];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClicked)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithWhite:0.856 alpha:1.000];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Stars"]];
    self.tableView.pagingEnabled = YES;
}
#pragma mark - TableView Datasourse & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section ==0) {
        return self.weatherHourlyForecast.count;
    }else if(section ==1){
        return self.weatherDailyForecast.count;
    }
        
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        HourlyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HourlyCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"HourlyTableViewCell" owner:nil options:nil].firstObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        WeatherHourlyForecast *weatherHourlyForecast = self.weatherHourlyForecast[indexPath.row];
        cell.hourlyTimeLabel.text = [NSString stringWithFormat:@"%@",[weatherHourlyForecast.date substringFromIndex:11]];
        cell.hourlyHumLabel.text = [NSString stringWithFormat:@"相对湿度:%@",weatherHourlyForecast.hum];
        cell.hourlyTmpLabel.text = [NSString stringWithFormat:@"%@℃",weatherHourlyForecast.tmp];
        NSString *scTmpStr =[((NSString*)weatherHourlyForecast.wind[@"sc"])isEqualToString:@"微风"]?@"":@"级";
        cell.hourlyWindLabel.text = [NSString stringWithFormat:@"%@%@ %@",weatherHourlyForecast.wind[@"sc"],scTmpStr,weatherHourlyForecast.wind[@"dir"]];
        return cell;
    }else if(indexPath.section == 1){
        DailyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DailyCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"DailyTableViewCell" owner:nil options:nil].firstObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        WeatherDailyForecast *weatherDailyForecast = self.weatherDailyForecast[indexPath.row];
        
        cell.dailyDayImageView.image = [UIImage imageNamed:weatherDailyForecast.cond[@"code_d"]];
        cell.dailyNightImageView.image = [UIImage imageNamed:weatherDailyForecast.cond[@"code_n"]];
        cell.dailyDayCondLabel.text = [NSString stringWithFormat:@"白天:%@",weatherDailyForecast.cond[@"txt_d"]];
        cell.dailyNightCondLabel.text = [NSString stringWithFormat:@"夜间:%@",weatherDailyForecast.cond[@"txt_n"]];
        NSString *scTmpStr =[((NSString*)weatherDailyForecast.wind[@"sc"])isEqualToString:@"微风"]?@"":@"级";
        cell.dailyTmpAndWindLabel.text = [NSString stringWithFormat:@"%@%@ %@-%@℃",weatherDailyForecast.wind[@"sc"],scTmpStr,weatherDailyForecast.tmp[@"min"],weatherDailyForecast.tmp[@"max"]];
        cell.dailyDateLabel.text = [NSString stringWithFormat:@"%@",weatherDailyForecast.date];

        return cell;
    }
    
    // Configure the cell...
    
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        self.mainHeaderView = [[NSBundle mainBundle]loadNibNamed:@"MainHeaderView" owner:nil options:nil].firstObject;
        [self refreshMainWeatherInfo];
        return self.mainHeaderView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return SCREEN_HEIGHT+64;
    }
    return 44;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return (SCREEN_HEIGHT-64)/self.weatherHourlyForecast.count*1.0;
    }else if(indexPath.section ==1){
        return (SCREEN_HEIGHT-64)/self.weatherDailyForecast.count*1.0;
    }
    
    return 0;
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
#pragma mark - 懒加载
- (NSArray *)weatherHourlyForecast {
	if(_weatherHourlyForecast == nil) {
        
        WeatherHourlyForecast *hourlyForecast = [WeatherHourlyForecast new];
        _weatherHourlyForecast = @[hourlyForecast,hourlyForecast,hourlyForecast,hourlyForecast,hourlyForecast];
	}
	return _weatherHourlyForecast;
}

- (NSArray *)weatherDailyForecast {
	if(_weatherDailyForecast == nil) {
        WeatherDailyForecast *dailyForecast = [WeatherDailyForecast new];
        _weatherDailyForecast = @[dailyForecast,dailyForecast,dailyForecast,dailyForecast,dailyForecast,dailyForecast,dailyForecast];
	}
	return _weatherDailyForecast;
}

@end
