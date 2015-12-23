//
//  FirstPageSubModel.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/2.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "FirstPageSubModel.h"

@implementation FirstPageSubModel

+ (NSMutableArray *)parseRespondsData:(NSData*)data{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *array = dic[@"data"][@"list"];
  //  NSLog(@"%@",array);
    NSMutableArray *mArr = [[NSMutableArray alloc]init];
    for (NSDictionary *dictionary in array) {
        FirstPageSubModel *model = [[FirstPageSubModel alloc]init];
        [model setValuesForKeysWithDictionary:dictionary];
        
        [mArr addObject:model];
    }
        for (FirstPageSubModel *f in mArr) {
            NSLog(@"%@",f.content);
        }
    return mArr;
}

@end
