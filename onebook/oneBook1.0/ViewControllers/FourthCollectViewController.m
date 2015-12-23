//
//  FourthCollectViewController.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/12.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "FourthCollectViewController.h"
#import "ThitdCollectionModel.h"
#import "FourthCollectTableViewCell.h"
@interface FourthCollectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic)UITableView    *tableView;
@property (nonatomic)NSMutableArray *dataArray;
@property(nonatomic)UILabel         *squareLable;
@end

@implementation FourthCollectViewController
- (void)viewWillAppear:(BOOL)animated{
    [self requestData];
    if (_dataArray.count == 0) {
        [self.view addSubview:self.squareLable];
        [self testFlyInAnimation];
        self.squareLable.hidden = NO;

    }
    if (_dataArray.count != 0) {
        self.squareLable.hidden = YES;
    }
    [self.tableView reloadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self requestData];
    self.title = @"我的收藏";
   
    [self createNavigation];
}
- (void)createNavigation{
    UIBarButtonItem * rightBtnItem=[[UIBarButtonItem alloc]initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(collectManage)];
    self.navigationItem.rightBarButtonItem=rightBtnItem;
}



- (void)requestData{
    NSArray *arr = [ThitdCollectionModel MR_findAll];
    _dataArray = [NSMutableArray arrayWithArray:arr];
    if (_dataArray.count == 0) {
        [self.view addSubview:self.squareLable];
        [self testFlyInAnimation];
        self.squareLable.hidden = NO;
    }

//    for (ThitdCollectionModel *t in _dataArray) {
//        NSLog(@"imageUrl = %@ content = %@ dateTime = %@",t.imageUrl,t.content,t.dateTime);
//    }
}
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
        

        _tableView.dataSource = self;
        _tableView.delegate = self;
        //去除垂直的滚动条的指示
        _tableView.showsVerticalScrollIndicator = NO;
        //取消tableView自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 44;
        UINib *nib = [UINib nibWithNibName:@"FourthCollectTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"cellID"];
    }
    return _tableView;
}

- (void)collectManage{
    if (_tableView.editing) {
    
        self.navigationItem.leftBarButtonItem = nil;
        //
        self.navigationItem.leftBarButtonItem.title = @"编辑";
        _tableView.editing=NO;
    }else{
        //[self.navigationController.navigationItem setHidesBackButton:YES];
        [self.navigationItem setHidesBackButton:YES];
        
        //创建删除按钮
        UIBarButtonItem * deleteBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeRows)];
        self.navigationItem.rightBarButtonItem = deleteBtnItem;
        //
        UIBarButtonItem * backBtnItem=[[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        //UIBarButtonItem * backBtnItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = backBtnItem;
        _tableView.editing=YES;
    }

}
- (void)back{
    
    _tableView.editing = NO;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [self.navigationItem setHidesBackButton:NO];
    [self createNavigation];
    [self.tableView reloadData];
}
-(void)removeRows{
    if (_tableView.editing) {
        //1，删除数据源
        NSLog(@"%@",_tableView.indexPathsForSelectedRows);
        //用户选中的要删除的行的坐标索引
        NSArray * selectedArr=_tableView.indexPathsForSelectedRows;
        //把用户选中的行的索引进行倒序排序
        NSArray * sortedArr=[selectedArr sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath * obj1, NSIndexPath * obj2) {
            return obj1.row<obj2.row;
        }];
        NSLog(@"%@",sortedArr);
        //遍历删除元素
        for (NSInteger i = 0; i < sortedArr.count; i++) {
             NSIndexPath * oneIndexPath = sortedArr[i];
            NSArray *allModel = [ThitdCollectionModel MR_findAll];
            ThitdCollectionModel *model = [allModel objectAtIndex:oneIndexPath.row];
            //删除一个对象
            [model MR_deleteEntity];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
           
            NSMutableArray * sectionArr = _dataArray;
            NSLog(@"%@",_dataArray);
            [sectionArr removeObjectAtIndex:oneIndexPath.row];
        }
        //2界面上面消除
        [_tableView deleteRowsAtIndexPaths:selectedArr withRowAnimation:UITableViewRowAnimationFade];

    }
    if (_dataArray.count == 0) {
        [self.view addSubview:self.squareLable];
        [self testFlyInAnimation];
        self.squareLable.hidden = NO;
    }

}
#pragma mark - 编辑相关的操作 -

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了第%ld组 第%ld行",indexPath.section,indexPath.row);
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"取消选择了第%ld组 第%ld行",indexPath.section,indexPath.row);
}
#pragma mark - 移动 -

//tableView询问某行是否可以移动
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    //调整数据源
    //取出sourceIndexPath对应的元素
    id oneItem = [_dataArray[sourceIndexPath.section] objectAtIndex:sourceIndexPath.row];
    //删除原来数组的记录
    [_dataArray[sourceIndexPath.section] removeObjectAtIndex:sourceIndexPath.row];
    //插入到目标位置
    [_dataArray[destinationIndexPath.section] insertObject:oneItem atIndex:destinationIndexPath.row];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FourthCollectTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    

    ThitdCollectionModel *model = self.dataArray[indexPath.row];
    [cell updateWithModel:model];
    
    
    return cell;
}
- (UILabel*)squareLable{
    if (_squareLable == nil) {
        _squareLable = [[UILabel alloc]initWithFrame:CGRectZero];
        
        _squareLable.layer.cornerRadius = 5.0;
        _squareLable.layer.bounds = CGRectMake(0, 0, SCREEN_WIDTH-40, (SCREEN_WIDTH-40)*0.4);
        _squareLable.layer.position = CGPointMake(SCREEN_WIDTH /2, 200);
        _squareLable.layer.backgroundColor = [UIColor colorWithRed:0.16 green:0.72 blue:1.0 alpha:0.9].CGColor;
        //初始值不可见
        _squareLable.layer.opacity = 0.0;
        //开始向左旋转一个角度
        CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_4/8);
        _squareLable.text = @"你的收藏夹空空如也,去前面寻找自己喜欢的文字收藏一下吧!";
         _squareLable.font = [UIFont fontWithName:@"Heiti TC" size:20];
        _squareLable.numberOfLines = 0;
        [_squareLable.layer setAffineTransform:transform];
        
    }
    return _squareLable;
}
- (void)testFlyInAnimation
{
    //对y坐标做弹簧动画
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    springAnimation.fromValue = @(-200);
    springAnimation.toValue   = @(self.view.center.y);
    springAnimation.springBounciness = 10;
    springAnimation.springSpeed = 20;
    
    //对opacity做基础动画
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    //设置动画的时间曲线，开始和结束慢，中间变化快
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置动画运行的时间
    opacityAnimation.duration = 0.2;
    //开始时间，CACurrentMediaTime获取当前时间
    //opacityAnimation.beginTime = CACurrentMediaTime() + 0.1;
    opacityAnimation.toValue
    = @(1.0);
    
    //对Rotation（旋转）做基础动画
    POPBasicAnimation *rotationAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotationAnimation.beginTime = CACurrentMediaTime() + 0.1;
    rotationAnimation.duration = 0.3;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.fromValue = @(-M_PI_4/8);
    //设置为0说明不旋转
    rotationAnimation.toValue = @(0);
    
    [self.squareLable.layer pop_addAnimation:springAnimation forKey:@"yPostion"];
    [self.squareLable.layer pop_addAnimation:opacityAnimation forKey:@"opacity"];
    [self.squareLable.layer pop_addAnimation:rotationAnimation forKey:@"rotation"];
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
