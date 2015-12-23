//
//  SecondTopView.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/8.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "SecondTopView.h"
@interface SecondTopView()
@property (weak, nonatomic) IBOutlet UILabel *dayLable;
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UILabel *lunarCalendarLable;

@property (weak, nonatomic) IBOutlet UIScrollView *oneSentenceScrollView;
@property (nonatomic)UILabel *lable;

@end
@implementation SecondTopView

- (void)awakeFromNib{
    self.lable = [[UILabel alloc]initWithFrame:CGRectZero];
    self.lable.textColor = [UIColor whiteColor];
    self.lable.font = [UIFont systemFontOfSize:17];
    [self.oneSentenceScrollView addSubview:self.lable];
    self.oneSentenceScrollView.backgroundColor = [UIColor clearColor];
    NSString *strFile = [[NSBundle mainBundle]pathForResource:@"我的文档" ofType:@"txt"];
    NSString *str = [NSString stringWithContentsOfFile:strFile encoding:NSUTF8StringEncoding error:nil];
    NSArray *arr = [str componentsSeparatedByString:@"=="];
    //  NSLog(@"-----------------------%ld",arr.count);
    int n = arc4random()%374;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSArray *arr1 = [strDate componentsSeparatedByString:@"-"];
    self.dayLable.text = arr1[2];
    self.year.text = [NSString stringWithFormat:@"%@-%@",arr1[0],arr1[1]];
    
    
    
    
    NSDate *dateTime = [dateFormatter dateFromString:strDate];
    
    self.lunarCalendarLable.text = [Help getChineseCalendarWithDate:dateTime];
    self.lable.text = arr[n];
    [self.lable sizeToFit];
    CGSize lableSize = self.lable.bounds.size;
    self.lable.frame = CGRectMake(_oneSentenceScrollView.bounds.size.width, 0, lableSize.width, lableSize.height);
    self.oneSentenceScrollView.contentSize =  CGSizeMake(lableSize.width + _oneSentenceScrollView.bounds.size.width , _oneSentenceScrollView.bounds.size.height);
     NSTimer *timer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
     [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)onTimer:(NSTimer*)timer{
     CGFloat xOffset = self.oneSentenceScrollView.contentOffset.x;
    if (xOffset > self.oneSentenceScrollView.contentSize.width) {
        xOffset = 0;
    }else{
        xOffset += 2;
    }
self.oneSentenceScrollView.contentOffset = CGPointMake(xOffset, 0);

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
