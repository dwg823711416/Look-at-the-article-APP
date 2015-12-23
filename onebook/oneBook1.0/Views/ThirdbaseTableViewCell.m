//
//  ThirdbaseTableViewCell.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/11.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "ThirdbaseTableViewCell.h"

@interface ThirdbaseTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *jokeLable;
@property (nonatomic) ThirdNewModel *model;
@property (nonatomic) NSString *imageUrl;
@property (nonatomic)NSMutableArray *mArr;
@property (nonatomic)ThitdCollectionModel *collectionModel;
@end
@implementation ThirdbaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)updateWithModel:(ThirdNewModel *)model{
    _mArr = [[NSMutableArray alloc]init];
    self.model = model;
    NSString *imageName = model.image;
    NSString *imageId = [NSString stringWithFormat:@"%ld",model.id];
    NSString *str = [imageId substringToIndex:[imageId length]-4];
   _imageUrl = [NSString stringWithFormat:URL_THIRD_IMAGE,str,imageId,imageName];
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
    [self.contentView addSubview:self.topImageView];
    //NSLog(@"%@\n%@",imageId,str);
    self.jokeLable.text = model.content;
    [self setNeedsLayout];

}
#pragma mark -
#pragma mark 收藏

//收藏
- (IBAction)collectButton:(id)sender {
    self.collectButton.tag = 1000;
    if ([_delegate respondsToSelector:@selector(choseThirdbaseTableViewCell:buttonTag:)]) {
        [_delegate choseThirdbaseTableViewCell:self.model buttonTag:self.collectButton.tag];
    }
 }


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
