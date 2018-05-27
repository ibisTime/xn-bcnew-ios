//
//  AnalysisViewController.m
//  ljs
//
//  Created by zhangfuyu on 2018/5/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AnalysisViewController.h"
//Category
#import "UILabel+Extension.h"
//M
#import "PlatformModel.h"
//V
#import "CurrencyInfoView.h"
#import "CurrencyTrendMapView.h"
#import "SelectScrollView.h"
#import "CurrencyInfoChildVC.h"
#import "CurrencyInfoTableView.h"



@interface AnalysisViewController ()<UIScrollViewDelegate>
//头部数据
@property (nonatomic, strong) CurrencyInfoView *infoView;
//趋势图
@property (nonatomic, strong) CurrencyTrendMapView *trendView;
//项目信息
@property (nonatomic, strong) SelectScrollView *selectSV;

@property (nonatomic, assign) BOOL vcCanScroll;

@property (nonatomic, assign) BOOL canScroll;



@end

@implementation AnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目分析";
    self.vcCanScroll = NO;
    [self initSubviews];
    
    self.infoView.platform = self.platform;
    [self.infoView cahngeColorWithAnalysis];
    self.trendView.platform = self.platform;

    // Do any additional setup after loading the view.
}
- (void)initSubviews {
    
    //导航栏title
//    [self initTitleView];
    //滚动视图
    [self initScrollView];
    
    //头部数据
    [self initInfoView];
    
    //趋势图
    [self initTrendView];
    
    //添加子控制器
    [self initSelectScrollView];
    //
    [self addSubViewController];
    
    //添加通知
    [self addNotification];
    
}
- (void)initScrollView {
    self.canScroll = YES;
    self.bgSV.delegate = self;
    self.bgSV.height = kSuperViewHeight - kBottomInsetHeight;
}
#pragma mark - 通知
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCLeaveTop) name:@"SubVCLeaveTop" object:nil];
}
- (void)subVCLeaveTop {
    self.canScroll = YES;

    self.vcCanScroll = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initTitleView {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    
    //币种名称
    UILabel *symbolNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                     textColor:kWhiteColor
                                                          font:14.0];
    symbolNameLbl.textAlignment = NSTextAlignmentCenter;
    symbolNameLbl.numberOfLines = 0;
    
    NSString *toSymbol = [self.platform.toSymbol uppercaseString];
    
    NSString *text = [NSString stringWithFormat:@"%@\n%@", self.platform.exchangeCname, toSymbol];
    
    [symbolNameLbl labelWithString:text
                             title:toSymbol
                              font:Font(11.0)
                             color:kWhiteColor];
    
    [titleView addSubview:symbolNameLbl];
    [symbolNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        //        make.centerX.equalTo(@(-15));
        make.centerX.equalTo(@(-5));
        
    }];
    
    //向下箭头
    //    self.arrowIV = [[UIImageView alloc] initWithImage:kImage(@"下拉")];
    //
    //    [titleView addSubview:self.arrowIV];
    //    [self.arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.left.equalTo(symbolNameLbl.mas_right).offset(12);
    //        make.centerY.equalTo(symbolNameLbl.mas_centerY);
    //    }];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPullDown:)];
    [titleView addGestureRecognizer:tapGR];
    
    self.navigationItem.titleView = titleView;
    
    
}
- (void)initInfoView {
    
    self.infoView = [[CurrencyInfoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 95)];
    
    [self.bgSV addSubview:self.infoView];
}
- (void)initTrendView {
        
    self.trendView = [[CurrencyTrendMapView alloc] initWithFrame:CGRectMake(0, self.infoView.yy + 10, kScreenWidth, 190)];
    
    self.trendView.arrowEventBlock = ^{
        
       
    };
    
    [self.bgSV addSubview:self.trendView];
}
- (void)initSelectScrollView {
    
    
    NSArray *titles = @[ @"项目信息"];
    
    self.selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, self.trendView.yy + 10, kScreenWidth, kSuperViewHeight - kBottomInsetHeight) itemTitles:titles];
    
    [self.bgSV addSubview:self.selectSV];
    
}
- (void)addSubViewController {
    
//    BaseWeakSelf;
    
    
    CurrencyInfoChildVC *childVC = [[CurrencyInfoChildVC alloc] init];
    
    //            childVC.refreshSuccess = ^{
    //
    //                [weakSelf.tableView endRefreshHeader];
    //            };
    childVC.index = 0;
    childVC.platform = self.platform;
    childVC.view.frame = CGRectMake(0, 1, kScreenWidth, kSuperViewHeight - 40 - kBottomInsetHeight);
    childVC.vcCanScroll = NO;
    [self addChildViewController:childVC];
    
    [_selectSV.scrollView addSubview:childVC.view];
    
    
    self.bgSV.contentSize = CGSizeMake(kScreenWidth,CGRectGetMaxY(self.trendView.frame) + self.selectSV.yy);
    
    //转移手势
    CurrencyInfoTableView *tableView = (CurrencyInfoTableView *)[self.view viewWithTag:1802];
    
    UIPanGestureRecognizer *panGR = tableView.panGestureRecognizer;
    
    [self.bgSV addGestureRecognizer:panGR];
    
    
}
#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat bottomOffset = self.selectSV.y;
    
    CGFloat scrollOffset = scrollView.contentOffset.y;
    
    //子视图已经到顶部
    if (scrollOffset >= bottomOffset) {
        
        //当视图到达顶部时，使视图悬停
        scrollView.contentOffset = CGPointMake(0, bottomOffset);
        
        if (self.canScroll) {
            self.canScroll = NO;
            self.vcCanScroll = YES;

        }
            //转移手势
        TLTableView *tableView = (TLTableView *)[self.view viewWithTag:1802];

        UIPanGestureRecognizer *panGR = tableView.panGestureRecognizer;

        [scrollView addGestureRecognizer:panGR];
        
    } else {
        
        //处理tableview和scrollView同时滚的问题（当vc不能滚动时，设置scrollView悬停）
        if (!self.canScroll) {
            scrollView.contentOffset = CGPointMake(0, bottomOffset);
        }
        
    }
    
    self.bgSV.showsVerticalScrollIndicator =  NO;
    
}

- (void)setVcCanScroll:(BOOL)vcCanScroll
{
    
    for (CurrencyInfoChildVC *vc in self.childViewControllers) {
        
        vc.vcCanScroll = vcCanScroll;
    }
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
