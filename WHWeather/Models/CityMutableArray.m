//
//  CityMutableArray.m
//  WHWeather
//
//  Created by Wayne on 16/4/26.
//  Copyright © 2016年 WayneHu. All rights reserved.
//

#import "CityMutableArray.h"

@implementation CityMutableArray
- (BOOL)isEqual:(id)other
{
    if (other isEqualToString:<#(nonnull NSString *)#> self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        return <#comparison expression#>;
    }
}

- (NSUInteger)hash
{
    return [super hash];
}
@end
