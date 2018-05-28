//
//  QuotesPlatformVC.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
//V
#import "PlatformTableView.h"
//M
#import "PlatformTitleModel.h"
#import "OptionalListModel.h"
/**
 平台
 */
typedef void(^selectCurrent)(NSString *);

@interface QuotesPlatformVC : BaseViewController
//
@property (nonatomic, assign) PlatformType type;
//类型
@property (nonatomic, copy) NSString *kind;
//平台编号
@property (nonatomic, copy) NSString *code;
//title
@property (nonatomic, strong) PlatformTitleModel *titleModel;
//当前索引
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray <PlatformTitleModel *>*platformTitleList;
//自选列表
@property (nonatomic, strong) NSMutableArray <OptionalListModel *>*optionals;
@property (nonatomic, assign) NSInteger currentSegmentIndex;

//点击刷新
- (void)clickPlatformWithIndex:(NSInteger)index;

/**
 点击cell返回ID
 */
@property (nonatomic,copy)selectCurrent selectBlock;

@end
