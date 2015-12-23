//
//  Secondmodel.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/7.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "Secondmodel.h"

@implementation Secondmodel
+ (NSMutableArray *)parseRespondsData:(NSDictionary*)dic{
    NSMutableArray *mArr = [[NSMutableArray alloc]init];
    NSArray *arr = dic[@"res"][@"wallpaper"];
    for (NSDictionary *dic1 in arr) {
        Secondmodel *model = [[Secondmodel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        [mArr addObject:model];
    }
//    for (Secondmodel *m in mArr) {
//        NSLog(@"%@",m.img);
//    }
    return mArr;
}
@end
