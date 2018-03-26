//
//  ForumCircleChildVC.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
//M
#import "ForumDetailModel.h"

@interface ForumCircleChildVC : BaseViewController
//索引
@property (nonatomic, assign) NSInteger index;
//
@property (nonatomic, strong) ForumDetailModel *detailModel;
//刷新数据
@property (nonatomic, copy)  void(^refreshSuccess)();
//是否滚动
@property (nonatomic, assign) BOOL vcCanScroll;

@end
