//
//  TabBarModel.m
//  ILove
//
//  Created by qianfeng on 15/11/23.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "TabBarModel.h"

@implementation TabBarModel
//初始化 modle的类方法
+ (instancetype)modelWithTitle:(NSString*)title imageName:(NSString*)imageName className:(NSString*)className{

    return [[self alloc]initWithTitle:title imageName:imageName className:className];
}

//初始化modle的实例方法
- (id)initWithTitle:(NSString*)title imageName:(NSString*)imageName className:(NSString*)className{
    if (self = [super init]) {
        _title = title;
        _imageName = imageName;
        _className = className;
    }

    return self;
}

//获取正常状态下的图片
- (UIImage*)normalImage{
    return [UIImage imageNamed:self.imageName];
   return [[UIImage imageNamed:self.imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];


//imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] [selectedImage:[[UIImage imageNamed:@"tab_c0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}
@end
