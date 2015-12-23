//
//  SecondTableViewCell.h
//  oneBook1.0
//
//  Created by qianfeng on 15/12/8.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondCellModel.h"
@interface SecondTableViewCell : UITableViewCell
- (void)updateWithModel:(SecondCellModel *)model;
@end
