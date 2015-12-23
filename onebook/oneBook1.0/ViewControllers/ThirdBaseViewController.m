//
//  ThirdBaseViewController.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/11.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "ThirdBaseViewController.h"
#import "ThirdbaseTableViewCell.h"
#import "ThirdHotModel.h"
#import "ThirdNewModel.h"
#import "ThirdClassicModel.h"
#import "ThitdCollectionModel.h"
@interface ThirdBaseViewController ()<ThirdbaseTableViewCellDelegate, UITableViewDataSource,UITableViewDelegate>
@property (nonatomic)UITableView    *tableView;
@property (nonatomic)NSMutableArray *dataSouce;
@property (nonatomic)BOOL            isRefreshing;
@property (nonatomic)NSInteger       page;
@property (nonatomic)ThitdCollectionModel *collectionModel;
@end

@implementation ThirdBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar.png"] forBarMetrics:UIBarMetricsDefault];
    self.dataSouce = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self requestData];
    [self createRefreshHeadView];
    [self createRefreshFootView];
}

- (void)createRefreshHeadView
{
    //防止循环引用
    __weak typeof(self) weakSelf = self;
    
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //如果正在刷新中，直接返回
        if (weakSelf.isRefreshing) {
            return ;
        }
        //执行刷新
        weakSelf.isRefreshing = YES;
        //执行刷新
        [weakSelf.dataSouce removeAllObjects];
        weakSelf.page = 0;
        [weakSelf requestData];
        //刷新结束
        //1:刷表
        [weakSelf.tableView reloadData];
        //2:设置刷新状态为NO
        weakSelf.isRefreshing = NO;
        //3:通知刷新视图，结束刷新
        [weakSelf.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }];
}
- (void)createRefreshFootView
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.page++;
        //上拉加载更多结束
        [weakSelf requestData];
        
        [weakSelf.tableView reloadData];
        weakSelf.isRefreshing = NO;
        //让footView 结束刷新状态
        [weakSelf.tableView footerEndRefreshing];
    }];
}


- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
       //取消tableView自带的分割线
       _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 44;
        
        UINib *nib = [UINib nibWithNibName:@"ThirdbaseTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"cellID"];
    }
    return _tableView;
}

-(void)requestData{
    
    
    [[NetDataEngine sharedInstance] requestThirdCellWithPage:self.page viewId:self.viewId Success:^(id responsData) {
        NSArray *arr = [ThirdNewModel parseRespondsData:responsData];
        for (int indx = 0; indx < arr.count; indx++) {
            [self.dataSouce addObject:arr[indx]];
        }
        // NSLog(@"%@",responsData);
        [_tableView reloadData];

        [self.tableView reloadData];
    } failed:^(NSError *error) {
    }];;

}


#pragma mark -
#pragma mark <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ThirdbaseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ThirdNewModel *model = self.dataSouce[indexPath.row];
    cell.collectButton.tag = indexPath.row;
    [cell updateWithModel:model];
    
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"%ld",indexPath.row);

}

- (void)choseThirdbaseTableViewCell:(ThirdNewModel *)model buttonTag:(NSInteger)tag{
    NSArray *array = [ThitdCollectionModel MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"id=%ld",model.id]];
    if(array.count > 0){
        //提示已经收藏过
        UIAlertController *contoller = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经被收藏" preferredStyle:UIAlertControllerStyleAlert];
        [contoller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:contoller animated:YES completion:nil];
    }else{
        NSDate *date=[NSDate date];
        NSDateFormatter *format1=[[NSDateFormatter alloc]init];
        [format1 setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSString *str1=[format1 stringFromDate:date];
        NSString *imageName = model.image;
        NSString *imageId = [NSString stringWithFormat:@"%ld",model.id];
        NSString *str = [imageId substringToIndex:[imageId length]-4];
        NSString *imageUrl = [NSString stringWithFormat:URL_THIRD_IMAGE,str,imageId,imageName];
        //先判断是否已经收藏过，如果有收藏给出提示，否则保存到数据库中
        //根据vegetable_id 查找数据库中是否已经包含了该记录
        
        _collectionModel = [ThitdCollectionModel MR_createEntity];
        _collectionModel.content = model.content;
        _collectionModel.dateTime = str1;
        _collectionModel.imageUrl = imageUrl;
        _collectionModel.id = @(model.id);
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        UIAlertController *contoller = [UIAlertController alertControllerWithTitle:@"提示" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
        [contoller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:contoller animated:YES completion:nil];
    }
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
