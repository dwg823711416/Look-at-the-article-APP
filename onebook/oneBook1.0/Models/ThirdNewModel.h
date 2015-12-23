//
//  ThirdNewModel.h
//  oneBook1.0
//
//  Created by qianfeng on 15/12/11.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "BaseModel.h"

@interface ThirdNewModel : BaseModel
@property (nonatomic,copy)NSString *image;//图片名字
@property (nonatomic,copy)NSDictionary *user;//作者信息
@property (nonatomic,copy)NSDictionary *image_size;//图片信息
@property (nonatomic)NSInteger id;//图片的id;
@property (nonatomic,copy)NSString *content;//内容
@property (nonatomic)NSInteger omments_count;//评论
@property (nonatomic)NSInteger share_count;//分享
+ (NSMutableArray *)parseRespondsData:(NSData *)data;
@end
