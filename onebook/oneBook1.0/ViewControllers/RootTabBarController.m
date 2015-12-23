//
//  RootTabBarController.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/2.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "RootTabBarController.h"
#import "TabBarModel.h"
@interface RootTabBarController ()
@property (nonatomic)NSMutableArray *tabBarModelArray;
@end

@implementation RootTabBarController
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configTabBarModel];
        [self createContentViewControllers];
    }
    return self;
}

- (void)configTabBarModel
{
    self.tabBarModelArray = [NSMutableArray array];
    TabBarModel *firstModel = [TabBarModel modelWithTitle:@"书香天地" imageName:@"岁月人生_24px.png" className:@"FirstViewController"];
    
    TabBarModel *secondModel = [TabBarModel modelWithTitle:@"精彩片刻" imageName:@"精彩片刻_24px.png" className:@"SecondViewController"];
    
    TabBarModel *thirdModel = [TabBarModel modelWithTitle:@"糗态生活" imageName:@"欢乐人生.png" className:@"ThirdHappyViewController"];
    
    TabBarModel *fourthModel = [TabBarModel modelWithTitle:@"个人空间" imageName:@"个人空间.png" className:@"FourthViewController"];
    
    [self.tabBarModelArray addObject:secondModel];
    [self.tabBarModelArray addObject:firstModel];
    
    [self.tabBarModelArray addObject:thirdModel];
    [self.tabBarModelArray addObject:fourthModel];
    
}
//创建内容控制器
- (void)createContentViewControllers
{
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (int idx = 0; idx < self.tabBarModelArray.count; idx++) {
        TabBarModel *model = [self.tabBarModelArray objectAtIndex:idx];
        NSString *className = model.className;
        UIViewController *viewController = [[NSClassFromString(className) alloc] init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
        
        //配置在tabbar上的内容
        nav.tabBarItem.title = model.title;
        nav.tabBarItem.image = [model normalImage];
        [viewControllers addObject:nav];
    }
    
    //设置tabBar的底层的图片
    self.tabBar.backgroundImage = [UIImage imageNamed:@"TabBar背景.png"];
    //tabBar选中时，图片会使用tabBar的tintColor进行渲染,设置tintColoer
   
    self.tabBar.tintColor = [UIColor orangeColor];
    self.viewControllers    = viewControllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
