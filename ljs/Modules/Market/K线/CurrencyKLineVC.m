//
//  CurrencyKLineVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyKLineVC.h"
//Category
#import "UILabel+Extension.h"
//M
#import "PlatformModel.h"
//V
#import "QuotesChangeView.h"
#import "CurrencyInfoView.h"
#import "CurrencyBottomView.h"
#import "CurrencyKLineMapView.h"
//#import "SetWarningView.h"
#import "YBPopupMenu.h"
//C
#import "CurrencyKLineHScreenVC.h"
#import "WarningViewController.h"
#import "UIView+Extension.h"
//分析页面
#import "AnalysisViewController.h"

#define kBottomHeight 50

@interface CurrencyKLineVC ()<CurrencyBottomViewDelegate,YBPopupMenuDelegate>
//向下箭头
@property (nonatomic, strong) UIImageView *arrowIV;
//更换交易所和币种
@property (nonatomic, strong) QuotesChangeView *changeView;
//头部数据
@property (nonatomic, strong) CurrencyInfoView *infoView;
//k线图
@property (nonatomic, strong) CurrencyKLineMapView *kLineView;
//底部按钮
@property (nonatomic, strong) CurrencyBottomView *bottomView;
//设置预警
//@property (nonatomic, strong) SetWarningView *warningView;
//自选添加 删除
@property (nonatomic, strong)UIButton *informationCardBtn;
//币种信息
@property (nonatomic, strong) PlatformModel *platform;
//是否加载
@property (nonatomic, assign) BOOL isLoad;
//是否下拉
@property (nonatomic, assign) BOOL isDown;

@end

@implementation CurrencyKLineVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [self.navigationController.navigationBar setBackgroundImage:[self.platform.bgColor convertToImage] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isLoad = NO;
    _isDown = NO;
    //获取行情详情
    [self requestQuotesInfo];

}

#pragma mark - Init
- (QuotesChangeView *)changeView {
    
    if (!_changeView) {
        
        _changeView = [[QuotesChangeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
        
        [self.view addSubview:_changeView];
    }
    return _changeView;
}

- (void)initSubviews {

    //导航栏title
    [self initTitleView];
    //头部数据
    [self initInfoView];
    //K线图
    [self initKLineView];
//    //底部按钮
    [self initBottomView];
}

#pragma mark - Init
- (void)initTitleView {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    
    //币种名称
    UILabel *symbolNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                     textColor:kWhiteColor
                                                          font:14.0];
    symbolNameLbl.textAlignment = NSTextAlignmentCenter;
    symbolNameLbl.numberOfLines = 0;
    
    symbolNameLbl.text = [NSString stringWithFormat:@"%@/%@",[self.platform.symbol uppercaseString],[self.platform.toSymbol uppercaseString]];
    
//    NSString *text = [NSString stringWithFormat:@"%@\n%@", self.platform.exchangeCname,toSymbol];
    
//    [symbolNameLbl labelWithString:text
//                             title:toSymbol
//                              font:Font(11.0)
//                             color:kWhiteColor];
    
    [titleView addSubview:symbolNameLbl];
    [symbolNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        //        make.centerX.equalTo(@(-15));
        make.centerX.equalTo(@(-5));
        
    }];
    
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPullDown:)];
    [titleView addGestureRecognizer:tapGR];
    
    self.navigationItem.titleView = titleView;
    
//    [self.navigationController.navigationBar setBackgroundImage:[self.platform.bgColor convertToImage] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    
    self.informationCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.informationCardBtn addTarget:self action:@selector(addchouse) forControlEvents:UIControlEventTouchUpInside];
    [self.informationCardBtn setImage:[UIImage imageNamed:@"df_添加 圆"] forState:UIControlStateNormal];
    
    [self.informationCardBtn sizeToFit];
    UIBarButtonItem *informationCardItem = [[UIBarButtonItem alloc] initWithCustomView:self.informationCardBtn];
    
    
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = 22;
    
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn addTarget:self action:@selector(reloadWebview) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn setImage:[UIImage imageNamed:@"df_刷新"] forState:UIControlStateNormal];
    [settingBtn sizeToFit];
    UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    

    self.navigationItem.rightBarButtonItems  = @[fixedSpaceBarButtonItem,settingBtnItem];
    
}
- (void)reloadWebview
{
    [self.kLineView reloadWeb];
}

/**
 添加或删除自选
 */
- (void)addchouse
{
    [self checkLogin:^{
        TLNetworking *http = [TLNetworking new];
        
        http.code = @"628330";
        http.showView = self.view;
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"exchangeEname"] = self.platform.exchangeEname;
        http.parameters[@"symbol"] = self.platform.symbol;
        http.parameters[@"toSymbol"] = self.platform.toSymbol;
        
        [http postWithSuccess:^(id responseObject) {

            if ([self.platform.isChoice integerValue] == 1) {
                [self.bottomView.optionBtn setImage:kImage(@"自选白") forState:UIControlStateNormal];

//                [self.informationCardBtn setImage:[UIImage imageNamed:@"df_添加 圆"] forState:UIControlStateNormal];
                self.platform.isChoice = @"0";
                if (self.choose) {
                    self.choose([self.platform.isChoice integerValue]);
                }
                
            }
            else
            {
            [self.bottomView.optionBtn setImage:kImage(@"删除 红") forState:UIControlStateNormal];

//                [self.informationCardBtn setImage:[UIImage imageNamed:@"df_减"] forState:UIControlStateNormal];

                self.platform.isChoice = @"1";
                if (self.choose) {
                    self.choose([self.platform.isChoice integerValue]);
                }
            }
            
            [TLAlert alertWithMsg:@"操作成功"];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
}
- (void)initInfoView {
    
    self.infoView = [[CurrencyInfoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 95)];
    
    [self.bgSV addSubview:self.infoView];
}

- (void)initKLineView {
    
    BaseWeakSelf;
    
    CGFloat h = kSuperViewHeight - self.infoView.yy - kBottomHeight - kBottomInsetHeight;
    
    self.kLineView = [[CurrencyKLineMapView alloc] initWithFrame:CGRectMake(0, self.infoView.yy, kScreenWidth, h)];
    
    self.kLineView.horizontalScreenBlock = ^{
        
        CurrencyKLineHScreenVC *hScreenVC = [CurrencyKLineHScreenVC new];
        hScreenVC.platform = weakSelf.platform;
        
        [weakSelf.navigationController pushViewController:hScreenVC animated:YES];
    };
    
    [self.bgSV addSubview:self.kLineView];
}

- (void)initBottomView {


    self.bottomView = [[CurrencyBottomView alloc] initWithFrame:CGRectMake(0, kSuperViewHeight - kBottomHeight - kBottomInsetHeight, kScreenWidth, kBottomHeight)];
    self.bottomView.platform = self.platform;
    self.bottomView.kine = self;
//    self.bottomView.bottomBlock = ^(BottomEventType type) {
//
//        [weakSelf bottomEventType:type];
//    };
    self.bottomView.delegate = self;
    [self.view addSubview:self.bottomView];
}
#pragma mark - CurrencyBottomViewDelegate
- (void)selectBtnisChangeWrning:(BOOL)isChage with:(UIButton *)sender
{
    if (isChage) {
        NSLog(@"预警");
        BaseWeakSelf;
        //是否登录
        [self checkLogin:^{
            WarningViewController *warning = [[WarningViewController alloc]init];
            warning.platform = self.platform;
            [weakSelf.navigationController pushViewController:warning animated:YES];
           
        }];
    }
    else
    {
        [YBPopupMenu showRelyOnView:sender titles:@[@"USD",@"CNY",@"原价"] icons:nil menuWidth:90 delegate:self];

    }
}

/**
 打开分写页面
 */
- (void)opendAnalysisVC
{
    AnalysisViewController *analysisvc = [[AnalysisViewController alloc]init];
    analysisvc.platform = self.platform;
    [self.navigationController pushViewController:analysisvc animated:YES];
}



#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    switch (index) {
        case 0:
        {
            [self.infoView changeMoney:[NSString stringWithFormat:@"$%.2lf", [self.platform.lastUsdPrice doubleValue]]];
        }
            break;
        case 1:
        {
            [self.infoView changeMoney:[NSString stringWithFormat:@"¥%.2lf", [self.platform.lastCnyPrice doubleValue]]];

        }
            break;
            
        default:
        {
            [self.infoView changeMoney:[NSString stringWithFormat:@"%.2lf", [self.platform.lastPrice doubleValue]]];

        }
            break;
    }
}


- (void)clickPullDown:(UITapGestureRecognizer *)tapGR {
    
    if (!self.isDown) {
        
        [self.changeView show];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.arrowIV.transform = CGAffineTransformMakeRotation(M_PI);
            
        } completion:^(BOOL finished) {
            
            self.isDown = YES;
        }];
        
    } else {
        
        [self.changeView hide];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.arrowIV.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
            self.isDown = NO;
        }];
    }
}

#pragma mark - Data
- (void)requestQuotesInfo {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628352";
    http.showView = self.view;
    http.parameters[@"id"] = self.symbolID;
    if ([TLUser user].userId) {
        
        http.parameters[@"userId"] = [TLUser user].userId;
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        self.platform = [PlatformModel mj_objectWithKeyValues:responseObject[@"data"]];
        self.bottomView.platform = self.platform;
        [self initSubviews];
        
        if ([self.platform.isChoice integerValue] == 1) {
            [self.informationCardBtn setImage:[UIImage imageNamed:@"df_减"] forState:UIControlStateNormal];

        }
        else
        {
            [self.informationCardBtn setImage:[UIImage imageNamed:@"df_添加 圆"] forState:UIControlStateNormal];

        }
        
        self.infoView.platform = self.platform;
        self.kLineView.platform = self.platform;
        self.bottomView.backgroundColor = self.platform.bgColor;
        
    } failure:^(NSError *error) {
        
    }];
}



- (void)followOrCancelFollow {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628352";
    http.showView = self.view;
    http.parameters[@"id"] = self.symbolID;
    if ([TLUser user].userId) {
        
        http.parameters[@"userId"] = [TLUser user].userId;
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        self.platform = [PlatformModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.infoView.platform = self.platform;
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
