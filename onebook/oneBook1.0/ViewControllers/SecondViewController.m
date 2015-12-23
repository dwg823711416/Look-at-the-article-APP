//
//  SecondViewController.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/2.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "SecondViewController.h"
#import "Secondmodel.h"
#import "SecondCellModel.h"
#import "SecondTopView.h"
#import "SecondTableViewCell.h"
#import "AdScrollView.h"
//导入使用pop动画需要的头文件
#import <POP.h>
@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@property (nonatomic)UITableView      *tableView;
@property (nonatomic)NSInteger         currentPage;
@property (nonatomic)SecondTopView    *secondTopView;
@property (nonatomic)NSArray          *dataSouce;//储存图片
@property (nonatomic)NSMutableArray   *cellDataSouce;//储存cell上的内容
@property (nonatomic)UIView           *bookView;
@property (nonatomic)UIWebView        *textWebView;
@property (nonatomic)BOOL              isRefreshing;
@property (nonatomic)NSInteger         cellPage;
@property (nonatomic)BOOL              imageMove;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = YES;
    self.cellDataSouce = [NSMutableArray array];
    self.currentPage = 1;
    [self createnavigationBar];
    [self requestImageData];
    [self.view addSubview:self.tableView];
    //[_tableView addSubview:self.secondTopView];
    
    
    [self.view addSubview:self.bookView];
    [self.bookView addSubview:self.textWebView];
    [self createRefreshHeadView];
    [self createRefreshFootView];
    
    
    
}
- (void)createScrollView
{
    AdScrollView * scrollView = [[AdScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    scrollView.backgroundColor = [UIColor grayColor];
    //如果滚动视图的父视图由导航控制器控制,必须要设置该属性(ps,猜测这是为了正常显示,导航控制器内部设置了UIEdgeInsetsMake(64, 0, 0, 0))
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    scrollView.imageNameArray = self.dataSouce;
    scrollView.PageControlShowStyle = UIPageControlShowStyleRight;
    scrollView.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    
   // [scrollView setAdTitleArray:dataModel.adTitleArray withShowStyle:AdTitleShowStyleLeft];
    
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
    _tableView.tableHeaderView = scrollView;
    [self.tableView addSubview:self.secondTopView];
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
        [weakSelf.cellDataSouce removeAllObjects];
        weakSelf.currentPage = 1;
        [weakSelf requestCellData];
        weakSelf.isRefreshing = YES;
        
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
    [self requestCellData];
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        
        weakSelf.isRefreshing = YES;
        weakSelf.cellPage++;
        [weakSelf requestCellData];
        //上拉加载更多结束
        NSLog(@"++++++++++++++++++%ld",weakSelf.cellPage);
        [weakSelf.tableView reloadData];
        weakSelf.isRefreshing = NO;
        //让footView 结束刷新状态
        [weakSelf.tableView footerEndRefreshing];
    }];
}

- (void)createnavigationBar{
   self.title = @"精彩片刻";
}

- (void)requestImageData{
    [[NetDataEngine sharedInstance]requestSecondSuccess:^(id responsData) {
        self.dataSouce = [Secondmodel parseRespondsData:responsData];
        [self createScrollView];
        
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)requestCellData{
    [[NetDataEngine sharedInstance]requestSecondCellWithPage:self.cellPage Success:^(id responsData) {
     NSArray *arr = [SecondCellModel parseRespondsData:responsData];
    for (int indx = 0; indx < arr.count; indx++) {
            [self.cellDataSouce addObject:arr[indx]];
        }

       // NSLog(@"%@",responsData);
       
        [_tableView reloadData];
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-48)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //去除垂直的滚动条的指示
        _tableView.showsVerticalScrollIndicator = NO;
        //取消tableView自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 44;
        UINib *nib = [UINib nibWithNibName:@"SecondTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"tableViewCellID"];
    }
    return _tableView;
}

- (SecondTopView*)secondTopView{
    if (_secondTopView == nil) {
        UINib *nib = [UINib nibWithNibName:@"SecondTopView" bundle:nil];
        //使用UINib 创建对应的xib上所有的顶级视图，
        NSArray *array = [nib instantiateWithOwner:nil options:nil];
        for (UIView *view in array) {
            
            //isMemberOfClass 一个对象的类型是否为指定的类
            //[view isMemberOfClass:[HomeTopView class]];
            
            //判断某个对象是否属于一个类以及他的子类
            if ([view isKindOfClass:[SecondTopView class]]) {
                _secondTopView = (SecondTopView*)view;
                //设置homeTopView的坐标
                _secondTopView.frame = CGRectMake(10, 0, 300, 60);
                _secondTopView.backgroundColor = [UIColor clearColor];
                break;
            }
        }
    }
    return _secondTopView;

}


- (UIView*)bookView{
    if (_bookView == nil) {
        _bookView = [[UITextView alloc]initWithFrame:CGRectZero];
        
        _bookView.layer.cornerRadius = 5.0;
        _bookView.layer.bounds = CGRectMake(0, 0, SCREEN_WIDTH-40, (SCREEN_WIDTH-40)/0.9);
        _bookView.layer.position = CGPointMake(SCREEN_WIDTH /2, SCREEN_HEIGHT/2);
        _bookView.layer.backgroundColor = [UIColor colorWithRed:0.16 green:0.72 blue:1.0 alpha:0.9].CGColor;
        //初始值不可见
        _bookView.layer.opacity = 0.0;
        //开始向左旋转一个角度
        CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_4/8);
        [_bookView.layer setAffineTransform:transform];
        [self addPanGestrure];

    }
    return _bookView;
}

- (UIWebView *)textWebView {
    if (_textWebView == nil) {
        
        _textWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, -110, SCREEN_WIDTH-40, (SCREEN_WIDTH-40)/0.9 +100 +100)];//或者改成1000
        [_textWebView setBackgroundColor:[UIColor clearColor]];
        [_textWebView setOpaque:NO];
        
    }
    
    return _textWebView;
}
- (void)addPanGestrure
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGestrue:)];
    [self.bookView addGestureRecognizer:pan];
}

//由于pan 是持续性手势，这样一般需要根据手势的状态来决定行为
- (void)handlePanGestrue:(UIPanGestureRecognizer*)pan
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        //手势识别成功,把以前所有的物理动效清空
       
    }else if(pan.state == UIGestureRecognizerStateChanged){
        //手势持续期间
        //translationInView 手势在view上的偏移
        CGPoint offset = [pan translationInView:self.view];
        CGPoint center = self.bookView.center;
        center.x += offset.x;
        center.y += offset.y;
        self.bookView.center = center;
        
        //由于手势的偏移会累加，所以必须把手势的偏移归零
        [pan setTranslation:CGPointZero inView:self.view];
    }
}


#pragma mark -
#pragma mark  UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellDataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"tableViewCellID" forIndexPath:indexPath];
    SecondCellModel *model = [[SecondCellModel alloc]init];
    model = self.cellDataSouce[indexPath.row];
    //设置选中的式样：没有选中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    [cell updateWithModel:model];
    self.bookView.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self testFlyInAnimation];
    self.bookView.hidden = NO;
   
    SecondCellModel *model = [[SecondCellModel alloc]init];
    model = self.cellDataSouce[indexPath.row];
    NSString *urlString = [NSString stringWithFormat:URL_BOOK,model.contentid];
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    _textWebView.scrollView.bounces = NO;
    
    [_textWebView loadRequest:request];
    _textWebView.backgroundColor = [UIColor clearColor];
    for (UIView *aView in [_textWebView subviews])
    {
        if ([aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)aView setShowsVerticalScrollIndicator:NO];
            //右侧的滚动条
            
            [(UIScrollView *)aView setShowsHorizontalScrollIndicator:NO];
            //下侧的滚动条
        }
    }
    _textWebView.delegate = self;
}


#pragma mark -
#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.view endEditing:YES];
   [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //[MMProgressHUD dismissWithSuccess:@"文章加载完成"];
    //字体大小
    
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    [_textWebView stringByEvaluatingJavaScriptFromString:str];
    //    //字体颜色
    //    [_bookWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'"];
    //    //页面背景色
    [_textWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='333333'"];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    NSLog(@"%@",error);
    
}




- (void)testFlyInAnimation
{
    //对y坐标做弹簧动画
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    springAnimation.fromValue = @(-200);
    springAnimation.toValue   = @(SCREEN_HEIGHT/2 - 64);//@(self.view.center.y);
    springAnimation.springBounciness = 10;
    springAnimation.springSpeed = 20;
    
    //对opacity做基础动画
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    //设置动画的时间曲线，开始和结束慢，中间变化快
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置动画运行的时间
    opacityAnimation.duration = 0.5;
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
    
    [self.bookView.layer pop_addAnimation:springAnimation forKey:@"yPostion"];
    [self.bookView.layer pop_addAnimation:opacityAnimation forKey:@"opacity"];
    [self.bookView.layer pop_addAnimation:rotationAnimation forKey:@"rotation"];
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
