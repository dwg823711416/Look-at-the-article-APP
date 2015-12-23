//
//  ThirdbaseTableViewCell.h
//  oneBook1.0
//
//  Created by qianfeng on 15/12/11.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThirdNewModel.h"
#import "ThitdCollectionModel.h"
@protocol ThirdbaseTableViewCellDelegate<NSObject>
- (void)choseThirdbaseTableViewCell:(ThirdNewModel *)model buttonTag:(NSInteger)tag;
@end
@interface ThirdbaseTableViewCell : UITableViewCell
@property (assign, nonatomic) id<ThirdbaseTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;



- (void)updateWithModel:(ThirdNewModel *)model;
@end
