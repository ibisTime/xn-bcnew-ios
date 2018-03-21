//
//  QuotesPlatformVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "QuotesPlatformVC.h"

//Macro
//Framework
//Category
//Extension
//M
#import "PlatformModel.h"
//V
#import "BaseView.h"

@interface QuotesPlatformVC ()
//
@property (nonatomic, strong) NSArray <PlatformModel *>*platforms;
//平台
@property (nonatomic, strong) PlatformTableView *tableView;
//
@property (nonatomic, strong) BaseView *headerView;
//平台名称
@property (nonatomic, strong) UILabel *platformNameLbl;
//帖子数
@property (nonatomic, strong) UILabel *postNumLbl;

@end

@implementation QuotesPlatformVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //头部
    [self initHeaderView];
    //
    [self initTableView];
    //获取平台列表
    [self requestPlatformList];
}

#pragma mark - Init
- (void)initHeaderView {
    
    self.headerView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 85)];
    
    self.headerView.backgroundColor = kWhiteColor;
    
    //平台名称
    self.platformNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor
                                                        font:17.0];
    self.platformNameLbl.text = @"币安";
    [self.headerView addSubview:self.platformNameLbl];
    [self.platformNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@10);
        make.top.equalTo(@10);
    }];
    //阴影
    UIView *shadowView = [[UIView alloc] init];
    
    shadowView.backgroundColor = kWhiteColor;
    shadowView.layer.shadowColor = kAppCustomMainColor.CGColor;
    shadowView.layer.shadowOpacity = 0.8;
    shadowView.layer.shadowRadius = 2;
    shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    shadowView.layer.cornerRadius = 4;
    
    [self.headerView addSubview:shadowView];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-kWidth(25)));
        make.width.equalTo(@87);
        make.height.equalTo(@40);
    }];
    //进吧
    UIButton *forumBtn = [UIButton buttonWithTitle:@"进吧"
                                        titleColor:kWhiteColor
                                   backgroundColor:kAppCustomMainColor
                                         titleFont:15.0
                                      cornerRadius:4];
    
    [self.headerView addSubview:forumBtn];
    [forumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-kWidth(25)));
        make.width.equalTo(@87);
        make.height.equalTo(@40);
    }];
    //帖子数
    self.postNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor
                                                   font:14.0];
    self.postNumLbl.numberOfLines = 0;
    self.postNumLbl.text = @"现在有12.3万个贴在讨论,你也一起来吧!";
    
    [self.headerView addSubview:self.postNumLbl];
    [self.postNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.platformNameLbl.mas_left);
        make.top.equalTo(self.platformNameLbl.mas_bottom).offset(10);
        make.right.equalTo(forumBtn.mas_left).offset(-15);
    }];
    
}

- (void)initTableView {
    
    self.tableView = [[PlatformTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.type = self.type;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    //判断是否是具体平台
    if (self.type == PlatformTypePlatform) {
        
        self.tableView.tableHeaderView = self.headerView;
    }
}

#pragma mark - Data
/**
 获取平台列表
 */
- (void)requestPlatformList {
    
    NSMutableArray <PlatformModel *>*arr = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        
        PlatformModel *model = [PlatformModel new];
        
        model.symbol = @"BTC";
        model.platformName = @"币安";
        model.price_cny = @"90000";
        model.price_usd = @"15555";
        model.one_day_volume_cny = @"10000000";
        model.one_day_volume_usd = @"1600000";
        model.unit = @"USDT";
        model.percent_change_24h = @"50";
        model.flow_percent_change_24h = @"50";
        model.in_flow_volume_cny = @"100亿";
        model.out_flow_volume_cny = @"50亿";
        model.flow_volume_cny = @"50亿";
        
        [arr addObject:model];
    }
    
    self.platforms = arr;
    
    self.tableView.platforms = self.platforms;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
