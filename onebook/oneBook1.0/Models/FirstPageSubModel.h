//
//  FirstPageSubModel.h
//  oneBook1.0
//
//  Created by qianfeng on 15/12/2.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "BaseModel.h"

@interface FirstPageSubModel : BaseModel
@property(nonatomic ,copy)NSString *id;
@property(nonatomic ,copy)NSString *title;
@property(nonatomic ,copy)NSString *content;
@property(nonatomic ,copy)NSString *name;

+ (NSMutableArray *)parseRespondsData:(NSData*)data;

@end
