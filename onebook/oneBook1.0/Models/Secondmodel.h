//
//  Secondmodel.h
//  oneBook1.0
//
//  Created by qianfeng on 15/12/7.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "BaseModel.h"

@interface Secondmodel : BaseModel
@property (nonatomic,copy)NSString *img;
+ (NSMutableArray *)parseRespondsData:(NSDictionary*)dic;
@end
