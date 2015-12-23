//
//  FirstPageSubTableViewCell.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/2.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "FirstPageSubTableViewCell.h"
@interface FirstPageSubTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (nonatomic) FirstPageSubModel *model;

@end
@implementation FirstPageSubTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)updateWithModel:(FirstPageSubModel *)model{
    
    self.label1.text = model.title;
    self.label2.text = model.content;
    NSLog(@"e-ee-------------%@",model.content);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
