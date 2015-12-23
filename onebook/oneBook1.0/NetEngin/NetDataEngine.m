//
//  NetDataEngine.m
//  oneBook1.0
//
//  Created by qianfeng on 15/12/2.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "NetDataEngine.h"
#import "AFNetworking.h"
@interface NetDataEngine ()
//网络请求类
@property(nonatomic)AFHTTPRequestOperationManager *httpManager;
@end

@implementation NetDataEngine

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static NetDataEngine *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [super allocWithZone:zone];
    });
    return s_instance;
}

+ (instancetype)sharedInstance{
    
    return [[self alloc]init];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _httpManager = [[AFHTTPRequestOperationManager alloc]init];
    }
    return self;
}
//获取岁月人生内容的网络请求
- (void)requestFirstPageSubDateWithTypeId:(NSString *)TypeId page:(NSInteger)page Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock{
    NSDictionary *parameters = @{@"sort":@"addtime",@"start":@"0",@"client":@"2",@"typeid":@"1",@"limit":@"10"};
    NSLog(@"++++++++%@",TypeId);
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    [mDic setValue:[NSString stringWithFormat:@"%ld",page*10] forKey:@"start"];
    [mDic setValue:TypeId forKey:@"typeid"];
   // NSLog(@"%@",parameters);
   // NSLog(@"%@",mDic);
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_async(globalQueue, ^{
        [self POST:URL_1 parameter:mDic success:successBlock failed:failedBlock];
        
        });
}
//获取精彩一天上cell上内容的网络请求

- (void)requestSecondCellWithPage:(NSInteger)page Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock{
    //sort=addtime&start=0&client=2&limit=10
    NSDictionary *parameters = @{@"sort":@"addtime",@"start":@"0",@"client":@"2",@"limit":@"10"};
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    [mDic setValue:[NSString stringWithFormat:@"%ld",page*10] forKey:@"start"];
    [self POST:URL_EVERY_DAY parameter:mDic success:successBlock failed:failedBlock];
}
//获取精彩一天上tableHeardView上图片的网络请求
- (void)requestSecondSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock{
    [_httpManager GET:URL_IMG parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

//把重复的代码封装起来
- (void)POST:(NSString*)url parameter:(NSDictionary *)dic success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock{
    _httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/x-javascript"];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    [MMProgressHUD showWithTitle:@"请稍候" status:@"数据加载中"];
  
    [_httpManager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successBlock) {
            successBlock(responseObject);
            [MMProgressHUD dismissWithSuccess:@"数据加载完成"];
             // NSLog(@"%@",responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [MMProgressHUD dismissWithSuccess:@"数据加载失败"];
    }];
}
//获取欢乐人生上cell上内容的网络请求
- (void)requestThirdCellWithPage:(NSInteger)page viewId:(NSInteger)viewId Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock{
    NSLog(@"%ld",viewId);
    NSString *url;
    if (viewId == 0) {
        url = [NSString stringWithFormat:URL_THIRD_HAPPY,page];
    }else if (viewId == 1){
        
        url = [NSString stringWithFormat:URL_THIRD_HOT,page];
    }else{
        url = [NSString stringWithFormat:URL_THIRD_CLASSIS,page];
    }
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    [MMProgressHUD showWithTitle:@"请稍候" status:@"数据加载中"];
    _httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [_httpManager GET:url parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
        [MMProgressHUD dismissWithSuccess:@"数据加载完成"];

       // NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failedBlock(error);
        [MMProgressHUD dismissWithSuccess:@"数据加载失败"];
        //NSLog(@"%@",error);
    }];

}







@end
