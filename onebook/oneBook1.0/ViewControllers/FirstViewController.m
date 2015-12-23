
//
//  FirstViewController.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/2.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstPageMainTableViewCell.h"
#import "FirstPageSubTableViewCell.h"
#import "FirstPageSubModel.h"
#import "FirstPageTwoViewController.h"

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)UITableView    *mainTableView;
@property(nonatomic)UITableView    *subTableView;
@property(nonatomic)NSArray        *mainTitleArray;
@property(nonatomic)BOOL            isShowSubTableView;
@property(nonatomic)NSMutableArray *subDataSource;
@property(nonatomic)NSArray        *typeIdArray;
@property(nonatomic)UIImageView    *triangleImageView;
@property(nonatomic)NSInteger       page;
@property(nonatomic)BOOL            isRefreshing;
@property (nonatomic)NSString      *typeId;


@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.subDataSource = [[NSMutableArray alloc]init];
    self.mainTitleArray =  @[@"晨曦",@"黄昏",@"读书",@"访谈",@"旅行",@"人物",@"影视",@"命运",@"咬文嚼字"];
    self.typeIdArray = @[@"1",@"27",@"10",@"12",@"7",@"11",@"6",@"18",@"14"];
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.subTableView];
    //三角形指示的图标imagView
    [self.mainTableView addSubview:self.triangleImageView];
    [self customNavigationTitleView];
    [self createRefreshHeadView];
    [self createRefreshFootView];

}
- (void)createRefreshHeadView
{
    //防止循环引用
    __weak typeof(self) weakSelf = self;
    
    [self.subTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //如果正在刷新中，直接返回
        if (weakSelf.isRefreshing) {
            return ;
        }
        //执行刷新
        weakSelf.isRefreshing = YES;
      
        //刷新结束
        //1:刷表
        [weakSelf.subTableView reloadData];
        //2:设置刷新状态为NO
        weakSelf.isRefreshing = NO;
        //3:通知刷新视图，结束刷新
        [weakSelf.subTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }];
}
- (void)createRefreshFootView
{
    __weak typeof(self) weakSelf = self;
    [self.subTableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.page++;
        //上拉加载更多结束
        [weakSelf fetchSubTherapyDataWith:weakSelf.typeId];
        NSLog(@"++++++++++++++++++%@",weakSelf.typeId);
        [weakSelf.subTableView reloadData];
        weakSelf.isRefreshing = NO;
        //让footView 结束刷新状态
        [weakSelf.subTableView footerEndRefreshing];
    }];
}


- (UIImageView*)triangleImageView{
    if (_triangleImageView == nil) {
        _triangleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"三角标.png"]];
        //15 * 21
        _triangleImageView.bounds = CGRectMake(0, 0, 15, 21);
        _triangleImageView.center = CGPointMake(SCREEN_WIDTH-15/2, 20);
        //UIViewAutoresizingFlexibleLeftMargin  使用autoResizing 指定左侧灵活变化，意思是右侧跟父视图保持固定，当父视图frame变化的时候一直和父视图的右边保持固定距离
        _triangleImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        _triangleImageView.hidden = YES;
    }
    return _triangleImageView;
}

- (UITableView *)mainTableView{
    
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49-64) style:UITableViewStylePlain];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        //去除垂直的滚动条的指示
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.estimatedRowHeight = 44;
        
        //设置tableView的背景
        _mainTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Left-bg.png"]];
        //注册使用的cell
        UINib *nib = [UINib nibWithNibName:@"FirstPageMainTableViewCell" bundle:nil];
        [_mainTableView registerNib:nib forCellReuseIdentifier:@"mainCellID"];
    }
    return _mainTableView;
}

- (UITableView*)subTableView{
    if (_subTableView == nil) {
        _subTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 64, SCREEN_WIDTH, SCREEN_HEIGHT-49-64) style:UITableViewStylePlain];
        _subTableView.delegate = self;
        _subTableView.dataSource = self;
        _subTableView.showsVerticalScrollIndicator = NO;
        _subTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _subTableView.estimatedRowHeight = 44;
        _subTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Right-bg.png"]];
        //注册使用的cell
        UINib *nib = [UINib nibWithNibName:@"FirstPageSubTableViewCell" bundle:nil];
        [_subTableView registerNib:nib forCellReuseIdentifier:@"subCellID"];
    }
    return _subTableView;
}
//添加返回按钮
- (void)addGoBackButton
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 2, 45, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"首页-返回.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"首页-返回-选.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self addCustomNavItems:@[button] onLeft:YES];
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
- (void)goBack{
    self.triangleImageView.hidden = YES;
    self.triangleImageView.frame = CGRectMake(SCREEN_WIDTH-15/2, 0, 15, 21);
    //把tableView 复位，然后把清除返回按钮
    CGRect mainTblInitFrame = CGRectMake(0, 0, SCREEN_WIDTH, self.mainTableView.bounds.size.height);
    CGRect subTblInitFrame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.subTableView.bounds.size.height);
    //通过动画把位置复位
    [UIView animateWithDuration:0.5 animations:^{
        self.mainTableView.frame = mainTblInitFrame;
        self.subTableView.frame = subTblInitFrame;
    } completion:^(BOOL finished) {
        [self clearGoBackButton];
        self.isShowSubTableView = NO;
        [self.mainTableView reloadData];
    }];
}
- (void)clearGoBackButton
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = nil;
}
- (void)customNavigationTitleView{
   self.title = @"书香天地";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar.png"]forBarMetrics:UIBarMetricsDefault];
}


#pragma mark -
#pragma mark UITableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mainTableView){
       return self.mainTitleArray.count;
    }
    NSLog(@"--------%ld",self.subDataSource.count);
    return self.subDataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.subTableView) {
        return 80;
    }
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView){
    FirstPageMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCellID"];
    //设置选中的式样：没有选中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    NSString *title = self.mainTitleArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];

    [cell updateWith:title hiddenDetailLabel:self.isShowSubTableView];
    
    return cell;
    }else{
        //返回第二层的tableView上的cell
        FirstPageSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subCellID"];
        //配置数据
        FirstPageSubModel *model = [self.subDataSource objectAtIndex:indexPath.row];
        [cell updateWithModel:model];
        return cell;
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据选中的主项目，把第二级的项目列出
    if (tableView == self.mainTableView) {
        NSString *firstPageTypeId = [self.typeIdArray objectAtIndex:indexPath.row];
        [self.subDataSource removeAllObjects];
        //请求Sub的数据
        [self fetchSubTherapyDataWith:firstPageTypeId];
        
        //计算mainTableView的最终的目的
        CGRect mainTblDestFrame = CGRectMake(0, 0, 100, self.mainTableView.bounds.size.height);
        CGRect subTblDestFrame = CGRectMake(100, 0, self.subTableView.bounds.size.width, self.subTableView.bounds.size.height);
        //移动三角形center 的坐标,先计算最终的位置
       CGPoint triangleDestCenter = CGPointMake(mainTblDestFrame.size.width-6, indexPath.row*80+26);
        NSLog(@"%@",NSStringFromCGPoint(triangleDestCenter));
        _triangleImageView.hidden = NO;
        //移动2个tableView
        [UIView animateWithDuration:0.5 animations:^{
            self.mainTableView.frame = mainTblDestFrame;
            self.subTableView.frame  = subTblDestFrame;
            self.triangleImageView.center = triangleDestCenter;
        } completion:^(BOOL finished) {
            //添加返回按钮
            [self addGoBackButton];
            //1:记录右边的tableView已经显示的状态  －》生成变量
            self.isShowSubTableView = YES;
            //2:重新构建mainTableView的cell ->reloadData
            [self.mainTableView reloadData];
            //3:在构建cell时根据状态来决定cell 上的详情信息是否现实－>配置cell时 cellForRowAtIndexPath
          
            //使用代码的方式使一行一直处于选中状态
            [self.mainTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];
    }
    if (tableView == self.subTableView) {
        FirstPageSubModel *subModel = [[FirstPageSubModel alloc]init];
        subModel = self.subDataSource[indexPath.row];
        FirstPageTwoViewController *FTVC = [[FirstPageTwoViewController alloc]init];
        FTVC.contentid = subModel.id;
        [self.navigationController pushViewController:FTVC animated:YES];
    }
}

- (void)fetchSubTherapyDataWith:(NSString*)TypeId
{
    self.typeId = TypeId;
    [[NetDataEngine sharedInstance] requestFirstPageSubDateWithTypeId:TypeId page:_page Success:^(id responsData) {
        NSArray *arr = [FirstPageSubModel parseRespondsData:responsData];
        for (int indx = 0; indx < arr.count; indx++) {
            [self.subDataSource addObject:arr[indx]];
        }
        NSLog(@"self.subDataSource.count:========%ld",self.subDataSource.count);
        
       [self.subTableView reloadData];
        //让次表滚动到最上边
       [self.subTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];

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
