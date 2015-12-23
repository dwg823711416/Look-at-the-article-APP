//
//  SecondTableViewCell.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/8.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "SecondTableViewCell.h"
@interface SecondTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *authorLable;
@property (weak, nonatomic) IBOutlet UILabel *worksLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;

@end
@implementation SecondTableViewCell

- (void)awakeFromNib {
    
}

- (void)updateWithModel:(SecondCellModel *)model{
    self.titleLable.text = [NSString stringWithFormat:@"题目：%@", model.title];
    self.timeLable.text = model.addtime_f;
    self.worksLable.text = model.shortcontent;
    self.authorLable.text = [NSString stringWithFormat:@"作者：%@", model.userinfo[@"uname"]];
    
    if (model.firstimage.length == 0) {
        self.imageViewHeight.constant = 0;
    }else{
        self.imageViewHeight.constant = 300;
        [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.firstimage]];
    }
    [self setNeedsLayout];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
