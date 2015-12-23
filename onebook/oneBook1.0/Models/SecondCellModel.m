//
//  SecondCellModel.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/8.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "SecondCellModel.h"

@implementation SecondCellModel
+ (NSArray *)parseRespondsData:(NSData*)data{
    NSArray *arr = [NSArray array];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    arr = dic[@"data"][@"list"];
    NSMutableArray *mArr = [[NSMutableArray alloc]init];
    for (NSDictionary *dictionary in arr) {
        SecondCellModel *model = [[SecondCellModel alloc]init];
        [model setValuesForKeysWithDictionary:dictionary];
        [mArr addObject:model];
    }
//    for (SecondCellModel *s in mArr) {
//        NSLog(@"%@",s.title);
//    }
    
    return mArr;
}
@end
