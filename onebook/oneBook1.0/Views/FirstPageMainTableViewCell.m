//
//  FirstPageMainTableViewCell.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/2.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "FirstPageMainTableViewCell.h"
@interface FirstPageMainTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UILabel *lable2;

@end
@implementation FirstPageMainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)updateWith:(NSString *)title hiddenDetailLabel:(BOOL)isHidden{
    NSString *strFile = [[NSBundle mainBundle]pathForResource:@"我的文档" ofType:@"txt"];
    NSString *str = [NSString stringWithContentsOfFile:strFile encoding:NSUTF8StringEncoding error:nil];
    NSArray *arr = [str componentsSeparatedByString:@"=="];
  //  NSLog(@"-----------------------%ld",arr.count);
    int n = arc4random()%374;
    
    
    self.lable1.text = title;
    self.lable2.text = arr[n];
    if (isHidden) {
        self.lable2.hidden = YES;
        
    }else{
        self.lable2.hidden = NO;
        
    }


}

//当cell处于选中状态时调用该代理方法
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.lable1.textColor = [UIColor brownColor];
    }else{
        self.lable1.textColor = [UIColor blackColor];
    }
}

@end
