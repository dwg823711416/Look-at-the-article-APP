//
//  FourthViewController.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/2.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "FourthViewController.h"
#import "FourthCollectViewController.h"
#import "FourthTableViewCell.h"
#import "OurViewController.h"
@interface FourthViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) UIView      *headerView;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIImageView *FtImageView;
@property (nonatomic) NSArray     *Array;
@property (nonatomic) NSArray     *imageArray;
@property (nonatomic) UITableView *tableView;
@end

@implementation FourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar.png"] forBarMetrics:UIBarMetricsDefault];
    self.title = @"个人空间";
    _Array = @[@"我的收藏",@"关于我们",@"清楚缓存"];
    _imageArray = @[@"like1hl.png",@"about@2x.png",@"clean@2x.png"];
    [self customTableView];
   [self customImageView];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)customImageView{
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/4)];
    UIImage *image = [UIImage imageNamed:@"back.png"];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/ 2) - 40 , 25, 80, 80)];
    _imageView.image = image;
    [_headerView addSubview:_imageView];
    self.tableView.tableHeaderView = _headerView;
}

- (void)customTableView{
    
   self.tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,SCREEN_WIDTH, SCREEN_HEIGHT-44)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //去除垂直的滚动条的指示
    _tableView.showsVerticalScrollIndicator = NO;
    //取消tableView自带的分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *nib = [UINib nibWithNibName:@"FourthTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"cellID"];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.16 green:0.72 blue:1.0 alpha:0.8]];
    [self.view addSubview:self.tableView];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = self.tableView.contentOffset.y;
    //向上偏移量变正  向下偏移量变负
    if (yOffset < 0) {
        CGFloat factor = ABS(yOffset)+(SCREEN_HEIGHT/4);
        CGRect f = CGRectMake(-(SCREEN_WIDTH*factor/(SCREEN_HEIGHT/4)-SCREEN_WIDTH)/2,-ABS(yOffset), SCREEN_WIDTH*factor/(SCREEN_HEIGHT/4), factor);
        
        _imageView.frame = f;
    }else {
        CGRect f = _headerView.frame;
        f.origin.y = 0;
        _headerView.frame = f;
        _imageView.frame = CGRectMake(0, f.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT/4);
    }
}
#pragma mark -
#pragma mark UITableView 代理
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.Array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FourthTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateImageName:_imageArray[indexPath.row] title:_Array[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        FourthCollectViewController *FCVC = [[FourthCollectViewController alloc]init];
        [self.navigationController pushViewController:FCVC animated:YES];
    }else if (indexPath.row == 1){
        OurViewController *OVC = [[OurViewController alloc]init];
        OVC.title = @"关于我们";
        [self.navigationController pushViewController:OVC animated:YES];
        
    }else if (indexPath.row == 2){
         [self clearCache];
    }
}

- (void)clearCache
{
    //getSize 获取当前清除缓存的大小
    NSUInteger size = [[SDImageCache sharedImageCache] getSize];
    CGFloat sizeOfM = size*1.0/1024/1024;
    NSString *cacheString = [NSString stringWithFormat:@"缓存数据 %.2fM,是否清除",sizeOfM];
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"提示" message:cacheString preferredStyle:UIAlertControllerStyleActionSheet];
    [alterController addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //清除缓存的操作
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
    }]];
    [alterController addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alterController animated:YES completion:nil];
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
