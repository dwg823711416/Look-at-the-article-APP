//
//  SecondCellModel.h
//  oneBook1.0
//
//  Created by qianfeng on 15/12/8.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "BaseModel.h"

@interface SecondCellModel : BaseModel
@property (nonatomic,copy)NSString *contentid;
@property (nonatomic,copy)NSDictionary *userinfo;
@property (nonatomic,copy)NSString *addtime_f;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *firstimage;
@property (nonatomic,copy)NSString *shortcontent;

+ (NSArray *)parseRespondsData:(NSData*)data;
@end
