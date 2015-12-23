//
//  BaseModel.m
//  PicketKitchen
//
//  Created by lijinghua on 15/11/23.
//  Copyright © 2015年 lijinghua. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
   // NSLog(@"捕获到未定义的key=[%@]",key);
}

- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
