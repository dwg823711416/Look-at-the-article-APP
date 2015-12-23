//
//  FirstPageTwoViewController.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/3.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "FirstPageTwoViewController.h"

@interface FirstPageTwoViewController ()<UIWebViewDelegate>
@property(nonatomic)UIWebView *bookWebView;
@property (nonatomic)NSString *posthtml;
@property (nonatomic)AFHTTPRequestOperationManager *HTTPManager;
@end

@implementation FirstPageTwoViewController
-(id)init{
    if (self =[super init]) {
        self.HTTPManager =[[AFHTTPRequestOperationManager alloc] init];
        NSSet *currentAcceptSet = self.HTTPManager.responseSerializer.acceptableContentTypes;
        NSMutableSet *mset = [NSMutableSet setWithSet:currentAcceptSet];
        [mset addObject:@"application/x-javascript"];
        self.HTTPManager.responseSerializer.acceptableContentTypes = mset;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
  [MMProgressHUD showWithTitle:@"请稍候" status:@"文章加载中"];
    self.view.backgroundColor = [UIColor grayColor];
     [self createHttpPost];
}
-(void)createHttpPost{
    
    NSString *strUrl =self.contentid;
    NSDictionary *postBody =@{@"contentid":strUrl,@"client":@(2)};
    __weak typeof (self)weakSelf =self;
    [self.HTTPManager POST:URL_WEBBOOK parameters:postBody success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *data =responseObject[@"data"];
            self.posthtml = data[@"html"];
        }
        [weakSelf createWebView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)createWebView{
    self.bookWebView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.bookWebView.scrollView.bounces = NO;

    self.bookWebView.scalesPageToFit =YES;
    self.bookWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.bookWebView.delegate = self;
    [self.bookWebView loadHTMLString:self.posthtml baseURL:nil];
    [self.view addSubview:self.bookWebView];
    
    
}

#pragma mark -
#pragma mark NetRequest

- (void)webViewDidStartLoad:(UIWebView *)webView{
   
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
   [MMProgressHUD dismissWithSuccess:@"文章加载完成"];
    //字体大小
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '90%'";
    [_bookWebView stringByEvaluatingJavaScriptFromString:str];
    
//    //字体颜色
//    [_bookWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'"];
   

    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth=310;" //缩放系数
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "myimg.height = myimg.height * (maxwidth/oldwidth);"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    //页面背景色
    [_bookWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='333333'"];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *requestURL =[request URL];
    if (([[requestURL scheme] isEqualToString: @"http"] || [[requestURL scheme] isEqualToString:@"https"] || [[requestURL scheme] isEqualToString: @"mailto" ])
        && (navigationType == UIWebViewNavigationTypeLinkClicked)) {
        return ![[UIApplication sharedApplication] openURL:requestURL];
    }
    
    return YES;
//在这里判断是否链接对应的URL
    return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    NSLog(@"%@",error);
    
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
