//
//  QuotesVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "QuotesVC.h"
//Macro
//Framework
//Category
#import "UIBarButtonItem+convience.h"
//Extension
//M
#import "QuotesManager.h"
//V
#import "SelectScrollView.h"
#import "TopLabelUtil.h"
#import "OptionalTableView.h"

@interface QuotesVC ()<SegmentDelegate>
//顶部切换
@property (nonatomic, strong) TopLabelUtil *labelUnil;
//大滚动
@property (nonatomic, strong) UIScrollView *switchSV;
//小滚动
@property (nonatomic, strong) SelectScrollView *selectSV;
//类型
@property (nonatomic, copy) NSString *kind;
//
@property (nonatomic, strong) NSArray *titles;
//自选
@property (nonatomic, strong) OptionalTableView *tableView;

@end

@implementation QuotesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //顶部切换
    [self initSegmentView];
    //
    [self addItem];
}

#pragma mark - Init
- (void)addItem {
    //添加选择
    [UIBarButtonItem addLeftItemWithImageName:@"" frame:CGRectMake(0, 0, 40, 40) vc:self action:@selector(addSelect)];
    //搜索
    [UIBarButtonItem addRightItemWithImageName:@"" frame:CGRectMake(0, 0, 40, 40) vc:self action:@selector(search)];
}

- (void)initSegmentView {
    
    NSArray *titleArr = @[
                          @"自选",
                          @"平台",
                          @"币种"];
    
    CGFloat h = 30;
    
    self.labelUnil = [[TopLabelUtil alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 120, (44-h), kWidth(179), h)];
    
    self.labelUnil.delegate = self;
    self.labelUnil.backgroundColor = [UIColor clearColor];
    self.labelUnil.titleNormalColor = kWhiteColor;
    self.labelUnil.titleSelectColor = kThemeColor;
    self.labelUnil.titleFont = Font(16.0);
    self.labelUnil.lineType = LineTypeButtonLength;
    self.labelUnil.titleArray = titleArr;
    self.labelUnil.layer.cornerRadius = h/2.0;
    self.labelUnil.layer.borderWidth = 1;
    self.labelUnil.layer.borderColor = kWhiteColor.CGColor;
    
    self.navigationItem.titleView = self.labelUnil;
    
    //1.切换背景
    self.switchSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight)];
    [self.view addSubview:self.switchSV];
    [self.switchSV setContentSize:CGSizeMake(titleArr.count*self.switchSV.width, self.switchSV.height)];
    self.switchSV.scrollEnabled = NO;
    //2.行情列表
    NSArray *kindArr = @[kOptional,
                         kPlatform,
                         kCurrency];
    for (int i = 0; i < titleArr.count; i++) {
        
        self.kind = kindArr[i];
        
        if ([self.kind isEqualToString:kPlatform]) {
            
            self.titles = @[@"全部", @"资金", @"OKEx", @"BigONE", @"币安", @"ZB", @"Gate", @"Bitfinex"];
            
        } else if ([self.kind isEqualToString:kCurrency]) {
            
            self.titles = @[@"币价", @"新币", @"资金", @"BTC", @"BCH", @"ETH", @"LTC", @"ETC", @"XRP", @"TRX", @"RLC", @"VIEB"];
        }
        
        if ([self.kind isEqualToString:kPlatform] || [self.kind isEqualToString:kCurrency]) {
            
            //添加滚动
            [self initSelectScrollViewWithIdx:i];
            
        } else {
            //添加自选
            [self initOptionalTableView];
        }
    }
    
}

- (void)initOptionalTableView {
    
    self.tableView = [[OptionalTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.switchSV addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

- (void)initSelectScrollViewWithIdx:(NSInteger)idx {
    
    SelectScrollView *selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(idx*kScreenWidth, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) itemTitles:self.titles];
    
    [self.switchSV addSubview:selectSV];
    
    self.selectSV = selectSV;
    
    [self addSubViewController];
    
}

- (void)addSubViewController {
    
    if ([self.kind isEqualToString:kPlatform]) {
        
        
    } else {

    }
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
//        HomeChildVC *childVC = [[HomeChildVC alloc] init];
//
//        //        childVC.status = self.statusList[i];
//        childVC.kind = self.kind;
//        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight);
//
//        [self addChildViewController:childVC];
//
//        [self.selectSV.scrollView addSubview:childVC.view];

    }
}

#pragma mark - Events
- (void)addSelect {
    
    
}

- (void)search {
    
    
}

#pragma mark - SegmentDelegate
- (void)segment:(TopLabelUtil *)segment didSelectIndex:(NSInteger)index {
    
    [self.switchSV setContentOffset:CGPointMake((index - 1) * self.switchSV.width, 0)];
    [self.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
