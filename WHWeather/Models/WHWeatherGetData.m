//
//  WHWeatherGetData.m
//  WHWeather
//
//  Created by Wayne on 16/4/25.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "WHWeatherGetData.h"
static WHWeatherGetData* weatherData;
@interface WHWeatherGetData()
@property(nonatomic,strong) NSArray *weatherKeys;
@property(nonatomic,strong) NSString *searchID;

@end

@implementation WHWeatherGetData
-(NSArray *)weatherKeys{
    if (!_weatherKeys) {
        _weatherKeys = @[@"88ce5b1619704deeb51445481e3b9978",@"94457f89fc374f21b164d04e5d8bfd9c",@"d865476aaa8645fba6c473de11e682ed",@"ac02e2bd2e134e97b687ef08684bfec2",@"ac02e2bd2e134e97b687ef08684bfec2",@"f1744bf931f2407ca8e58ce9c88cbe19"];
    }
    return _weatherKeys;
}
+(void)weatherWithCity:(NSString*)searchID completionBlock:(BLOCK_GET_WEATHER)weatherBlock{
    if (!weatherData) {
        weatherData = [WHWeatherGetData new];
    }
    weatherData.searchID = searchID;
    int i = 0;
    [weatherData loadDic:i completionBlock:weatherBlock];
    
}
-(void)loadDic:(int)i completionBlock:(BLOCK_GET_WEATHER)weatherBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"https://api.heweather.com/x3/%@&key=%@",self.searchID,self.weatherKeys[i]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            
            NSError *dicError = nil;
            NSDictionary *dicFromJSON= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&dicError];
            if (dicError) {
                NSLog(@"error:%@",dicError.userInfo);
                
            }
            NSString *status;
            if([self.searchID containsString:@"weather"]){
                status =dicFromJSON[@"HeWeather data service 3.0"][0][@"status"];
//                weatherBlock(dicFromJSON,dicError);
//                return ;
            }else {
                status = dicFromJSON[@"status"];
            }
           
            if (![status isEqualToString:@"ok"]) {
                if (i>=self.weatherKeys.count-1) {
                    NSLog(@"您的所有key已失效，或者网络不可用，code:%@",error.userInfo);
                }else{
                    NSLog(@"连接失败，尝试第%d个key",i+1);
                    [self loadDic:i+1 completionBlock:weatherBlock];
                }
            }else{
                NSLog(@"连接成功");
                weatherBlock(dicFromJSON,dicError);
            }
        }else{
            
            NSLog(@"连接失败,error:%@",error.userInfo);
            
            
        }
    }];
    [dataTask resume];
}
/**
 *  获取所有城市信息，存入document路径
 */
+(void)searchAllChina{
    [self weatherWithCity:@"citylist?search=allchina" completionBlock:^(NSDictionary *dic, NSError *err) {
        if (!err) {
            NSString *documentPath =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
            NSString *filePath = [documentPath stringByAppendingPathComponent:@"allchina.plist"];
            NSArray *arr = dic[@"city_info"];
            NSLog(@"%@",arr);
            //加入拼音
            NSMutableArray *mutaArr = [NSMutableArray array];
            
            for (NSDictionary *dicFromArr in arr) {
                NSMutableDictionary *mutaDic = [NSMutableDictionary dictionaryWithDictionary:dicFromArr];
                NSString *cityName = dicFromArr[@"city"];
                NSString *cityPinyin = [weatherData translateToPinyinWithString:cityName];
                [mutaDic setObject:cityPinyin forKey:@"pinyin"];
                [mutaArr addObject:mutaDic];
            }
            [mutaArr writeToFile:filePath atomically:YES];
        }
    }];
}

/**
 *  获取所有景点信息，存入document路径
 */
+(void)searchAllAttractions{
    [self weatherWithCity:@"citylist?search=allattractions" completionBlock:^(NSDictionary *dic, NSError *err) {
        if (!err) {
            NSString *documentPath =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
            NSString *filePath = [documentPath stringByAppendingPathComponent:@"allattractions.plist"];
            NSArray *arr = dic[@"city_info"];
            NSLog(@"%@",arr);
            //加入拼音
            NSMutableArray *mutaArr = [NSMutableArray array];
            
            for (NSDictionary *dicFromArr in arr) {
                NSMutableDictionary *mutaDic = [NSMutableDictionary dictionaryWithDictionary:dicFromArr];
                NSString *cityName = dicFromArr[@"city"];
                NSString *cityPinyin = [weatherData translateToPinyinWithString:cityName];
                [mutaDic setObject:cityPinyin forKey:@"pinyin"];
                [mutaArr addObject:mutaDic];
            }
            [mutaArr writeToFile:filePath atomically:YES];
        }
    }];
}
/**
 *  获取所有天气状态，存入document路径
 */
+(void)searchAllCondition{
    [self weatherWithCity:@"condition?search=allcond" completionBlock:^(NSDictionary *dic, NSError *err) {
        if (!err) {
            NSString *documentPath =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
            NSString *filePath = [documentPath stringByAppendingPathComponent:@"allcond.plist"];
            NSArray *arr = dic[@"cond_info"];
            [arr writeToFile:filePath atomically:YES];
            //存图片
            NSString *imagesPath = [documentPath stringByAppendingPathComponent:@"images"];
            [[NSFileManager defaultManager]createDirectoryAtPath:imagesPath withIntermediateDirectories:YES attributes:nil error:nil];
            
            for (NSDictionary* infoDic in arr) {
                NSString *iconStr = infoDic[@"icon"];
                NSURL *iconURL =[NSURL URLWithString:iconStr];
                NSString *iconName = [iconStr lastPathComponent];
                NSString *iconPath = [imagesPath stringByAppendingPathComponent:iconName];
                NSURLSession *session = [NSURLSession sharedSession];
                NSURLSessionDataTask *dataTask = [session dataTaskWithURL:iconURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (!error) {
                        [data writeToFile:iconPath atomically:YES];
                    }
                }];
                [dataTask resume];
            }
            NSLog(@"%@",arr);
        }
    }];
}

-(NSString*)translateToPinyinWithString:(NSString*)str{
    //转成了可变字符串
    NSMutableString *selfStr = [NSMutableString stringWithString:str];

    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)selfStr,NULL, kCFStringTransformMandarinLatin,NO);

    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)selfStr,NULL, kCFStringTransformStripDiacritics,NO);

    //转化为大写拼音
    NSString *selfPinYin = [selfStr capitalizedString];
    
    //获取并返回首字母
//    NSString *selfFirstCase= [selfPinYin substringToIndex:1];
    
//    [self.firstCases addObject:selfFirstCase];
//    NSLog(@"%@",selfPinYin);
    return selfPinYin;
}


@end



