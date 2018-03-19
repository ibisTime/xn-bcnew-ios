//
//  TLComposeManager.m
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/25.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "TLComposeManager.h"
#import "QiniuSDK.h"

@implementation TLComposeManager


+ (instancetype)manager {

    static TLComposeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [TLComposeManager manager];
        
    });
    
    return manager;
}

+ (void)saveArticleToLocalAndBeginUpload:(TLComposeArticleItem *)article {

    if ([NSThread isMainThread] ) {
        NSLog(@"不要在主线程进行该操作");
        return;
    }
    //
    TLComposeImgItem *imgItem = [[TLComposeImgItem alloc] init];
    imgItem.code = [NSString stringWithFormat:@"%.3f",[NSDate timeIntervalSinceReferenceDate]];
    imgItem.imgData= UIImageJPEGRepresentation([UIImage imageNamed:@"user_placeholder"], 0.5);
    imgItem.shortUrl = @"图片url";
    
    //
    TLComposeArticleItem *testItem = [[TLComposeArticleItem alloc] init];
    testItem.code = [NSString stringWithFormat:@"%.3f",[NSDate timeIntervalSinceReferenceDate]];
    testItem.title = @"帖子标题";
    testItem.contentText = @"帖子内容";
    [testItem.imgs addObject:imgItem];
    
    //对象创建线程，和使用线程必须相同
    //1.保存到数据库
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        [[RLMRealm defaultRealm] addObject:testItem];
    }];
    
    //2.上传图片，给模型指定字段赋值
    QNUploadManager *upload = [[QNUploadManager  alloc] init];
    [upload putData:nil key:@"" token:@"" complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        //主线程
        //更改数据库中图片对象
        
    } option:nil];
    
    //3.图片上传完成，上传帖子至服务器
    
    
    //4.帖子上传完成，删除数据库中帖子相关，并通知用户
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        
        [[RLMRealm defaultRealm] deleteObject:testItem];
        
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"帖子上传完成");

    });
    NSLog(@"%@",NSHomeDirectory());
    


}

@end
