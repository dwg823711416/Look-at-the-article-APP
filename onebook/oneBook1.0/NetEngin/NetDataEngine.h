//
//  NetDataEngine.h
//  oneBook1.0
//
//  Created by qianfeng on 15/12/2.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SuccessBlockType) (id responsData);
typedef void(^FailedBlockType) (NSError *error);
@interface NetDataEngine : NSObject

+ (instancetype) sharedInstance;
//百代过客的网络数据请求
- (void)requestFirstPageSubDateWithTypeId:(NSString *)TypeId page:(NSInteger)page Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//获取精彩一天上tableHeardView上图片的网络请求
- (void)requestSecondSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//获取精彩一天上cell上内容的网络请求
- (void)requestSecondCellWithPage:(NSInteger)page Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//获取欢乐人生上cell上内容的网络请求
- (void)requestThirdCellWithPage:(NSInteger)page viewId:(NSInteger)viewId Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;



@end
