//
//  SearchCurrencyVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SearchCurrencyVC.h"
//Macro
//Framework
//Category
//Extension
//M
//V
#import "SelectScrollView.h"
//C
#import "SearchCurrcneyChildVC.h"

@interface SearchCurrencyVC ()
//
@property (nonatomic, strong) SelectScrollView *selectSV;
//titles
@property (nonatomic, strong) NSArray *titles;
//statusList
@property (nonatomic, strong) NSArray *statusList;

@end

@implementation SearchCurrencyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //搜索
    [self initSearchBar];
    //
    [self initSelectScrollView];
    //
    [self addSubViewController];
}

- (void)initSearchBar {
    
    [UINavigationBar appearance].barTintColor = kAppCustomMainColor;
    //搜索
    UIView *searchBgView = [[UIView alloc] init];
    //    UIView *searchBgView = [[UIView alloc] init];
    
    searchBgView.backgroundColor = kClearColor;
    searchBgView.userInteractionEnabled = YES;
    
    self.navigationItem.titleView = searchBgView;
    
    [searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
    }];
    //搜索按钮
    UIButton *btn = [UIButton buttonWithTitle:@"请输入平台/币种"
                                   titleColor:kWhiteColor
                              backgroundColor:[UIColor colorWithUIColor:kWhiteColor alpha:0.4]
                                    titleFont:15.0
                                 cornerRadius:15.0];
    //
    [btn addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchBgView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 0, 8, 0));
        
        make.width.mas_greaterThanOrEqualTo(kScreenWidth - 20 - 40 -  15);
        
    }];
    //
    [btn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -btn.titleLabel.width + 50)];
    //搜索文字
    UILabel *searchLbl = [UILabel labelWithFrame:CGRectMake(btn.xx + 2, 0, 80, btn.height)
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:Font(14)
                                       textColor:kTextColor2];
    [searchBgView addSubview:searchLbl];
    
    
    searchLbl.centerY = btn.centerY;
    [searchLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn.mas_centerX).offset(0);
        make.top.equalTo(btn.mas_top);
        make.height.equalTo(btn.mas_height);
    }];
    
}

- (void)initSelectScrollView {
    
    self.titles = @[@"热门搜索", @"历史搜索"];
    
    SelectScrollView *selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) itemTitles:self.titles];
    
    [self.view addSubview:selectSV];
    
    self.selectSV = selectSV;
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        //
        SearchCurrcneyChildVC *childVC = [[SearchCurrcneyChildVC alloc] init];
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight);
        
        [self addChildViewController:childVC];
        
        [self.selectSV.scrollView addSubview:childVC.view];
    }
}

#pragma mark - Events
- (void)clickSearch {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
