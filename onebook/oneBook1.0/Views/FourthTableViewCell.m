//
//  FourthTableViewCell.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/14.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "FourthTableViewCell.h"
@interface FourthTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *lable;


@end
@implementation FourthTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)updateImageName:(NSString *)imageName title:(NSString *)title{
    self.cellImageView.image = [UIImage imageNamed:imageName];
    self.lable.text = title;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
