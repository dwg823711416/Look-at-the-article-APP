//
//  ThirdHappyViewController.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/11.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "ThirdHappyViewController.h"
#import "ThirdClassisViewController.h"
#import "ThirdHotViewController.h"
@interface ThirdHappyViewController ()

@end

@implementation ThirdHappyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewId = 0;
    self.title = @"糗态生活";
    
    //    //配置导航栏左边items
    //    [self customNavigationLeftBarItems];
    //    //配置导航栏的titleView
    //    [self customNavigationTitleView];
    //配置导航栏右边的items
    [self customNavigationBarItems];
    
}

- (void)customNavigationBarItems{
    UIButton *liftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [liftButton setTitle:@"经典" forState:UIControlStateNormal];
    [liftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    liftButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self addCustomNavItems:@[liftButton] onLeft:YES];
    
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [rightButton setTitle:@"火热" forState:UIControlStateNormal];
    [liftButton addTarget:self action:@selector(liftNavButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(rightNavButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addCustomNavItems:@[rightButton] onLeft:NO];
}
- (void)addCustomNavItems:(NSArray*)viewItems onLeft:(BOOL)isLeft
{
    NSMutableArray *barButtonItemArray = [NSMutableArray array];
    for (UIView *view in viewItems) {
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:view];
        [barButtonItemArray addObject:barItem];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = barButtonItemArray;
    }else{
        self.navigationItem.rightBarButtonItems = barButtonItemArray;
    }
}
- (void)liftNavButtonAction{
    ThirdHotViewController *THVC = [[ThirdHotViewController alloc]init];
    THVC.viewId = 1;
    THVC.view.backgroundColor = [UIColor grayColor];
       [self.navigationController pushViewController:THVC animated:YES];
    
}

- (void)rightNavButtonAction{
    ThirdClassisViewController *TCVC = [[ThirdClassisViewController alloc]init];
    
    TCVC.viewId = 2;
    TCVC.view.backgroundColor = [UIColor purpleColor];
    [self.navigationController pushViewController:TCVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
