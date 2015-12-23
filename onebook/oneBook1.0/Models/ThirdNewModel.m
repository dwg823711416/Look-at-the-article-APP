//
//  ThirdNewModel.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/11.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "ThirdNewModel.h"

@implementation ThirdNewModel
+ (NSMutableArray *)parseRespondsData:(NSData *)data{
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *mArr = [NSMutableArray array];
    NSArray *arr = dic[@"items"];
    for (NSDictionary *dictionary in arr) {
        ThirdNewModel *model = [[ThirdNewModel alloc]init];
        [model setValuesForKeysWithDictionary:dictionary];
        [mArr addObject:model];
    }
//    for (ThirdNewModel *t in mArr) {
//        NSLog(@"%@",t.content);
//    }
    return mArr;
}
@end
