//
//  FourthCollectTableViewCell.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/12.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "FourthCollectTableViewCell.h"
@interface FourthCollectTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *collectImageView;
@property (weak, nonatomic) IBOutlet UILabel *collectlable;
@property (weak, nonatomic) IBOutlet UILabel *collectTime;

@end
@implementation FourthCollectTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)updateWithModel:(ThitdCollectionModel *)model{
 [self.collectImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    self.collectlable.text = model.content;
    self.collectTime.text = [NSString stringWithFormat:@"收藏时间：%@",model.dateTime];
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
