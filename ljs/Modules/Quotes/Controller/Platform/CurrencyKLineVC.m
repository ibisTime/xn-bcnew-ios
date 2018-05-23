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
//币种信息
@property (nonatomic, strong) PlatformModel *platform;
//是否加载
@property (nonatomic, assign) BOOL isLoad;
//是否下拉
@property (nonatomic, assign) BOOL isDown;

@end

@implementation CurrencyKLineVC

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

//- (SetWarningView *)warningView {
//
//    if (!_warningView) {
//
//        _warningView = [[SetWarningView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    }
//    return _warningView;
//}

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
    
    [self.navigationController.navigationBar setBackgroundImage:[self.platform.bgColor convertToImage] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
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
//        BaseWeakSelf;
//        [self checkLogin:^{
            WarningViewController *warning = [[WarningViewController alloc]init];
            warning.platform = self.platform;
            [self.navigationController pushViewController:warning animated:YES];
           
//        }];
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
#pragma mark - Events
//- (void)bottomEventType:(BottomEventType)type {
//
//    BaseWeakSelf;
//
//    switch (type) {
//
//        case BottomEventTypeEarlyWarning:
//        {
//            [self checkLogin:^{
//
//                weakSelf.warningView.platform = weakSelf.platform;
//
//                [weakSelf.warningView show];
//            }];
//
//        }break;
//
//        case BottomEventTypeFollow:
//        {
//            BaseWeakSelf;
//            [self checkLogin:^{
//
//                TLNetworking *http = [TLNetworking new];
//
//                http.code = @"628352";
//                http.showView = self.view;
//                http.parameters[@"id"] = self.symbolID;
//
//                [http postWithSuccess:^(id responseObject) {
//                    //刷新关注状态
//                    weakSelf.platform = [PlatformModel mj_objectWithKeyValues:responseObject[@"data"]];
//                    weakSelf.infoView.platform = weakSelf.platform;
//                    weakSelf.bottomView.platform = weakSelf.platform;
//
//                } failure:^(NSError *error) {
//
//                }];
//
//            } event:^{
//
//                [self followCurrency];
//            }];
//
//        }break;
//
//        case BottomEventTypeBuy:
//        {
//            SimulationTradeDetailVC *detailVC = [SimulationTradeDetailVC new];
//
//            detailVC.direction = @"0";
//
//            [self.navigationController pushViewController:detailVC animated:YES];
//        }break;
//
//        case BottomEventTypeSell:
//        {
//            SimulationTradeDetailVC *detailVC = [SimulationTradeDetailVC new];
//
//            detailVC.direction = @"1";
//
//            [self.navigationController pushViewController:detailVC animated:YES];
//        }break;
//
//        default:
//            break;
//    }
//}

- (void)clickPullDown:(UITapGestureRecognizer *)tapGR {
    
    if (!_isDown) {
        
        [self.changeView show];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.arrowIV.transform = CGAffineTransformMakeRotation(M_PI);
            
        } completion:^(BOOL finished) {
            
            _isDown = YES;
        }];
        
    } else {
        
        [self.changeView hide];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.arrowIV.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
            _isDown = NO;
        }];
    }
}

#pragma mark - Data
- (void)requestQuotesInfo {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628352";
    http.showView = self.view;
    http.parameters[@"id"] = /*self.symbolID*/@"1";
    if ([TLUser user].userId) {
        
        http.parameters[@"userId"] = [TLUser user].userId;
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        self.platform = [PlatformModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self initSubviews];
        
        self.infoView.platform = self.platform;
        self.kLineView.platform = self.platform;
        self.bottomView.backgroundColor = self.platform.bgColor;
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 关注
 */
//- (void)followCurrency {
//    
//    TLNetworking *http = [TLNetworking new];
//    
//    http.code = @"628330";
//    http.showView = self.view;
//    http.parameters[@"exchangeEname"] = self.platform.exchangeEname;
//    http.parameters[@"userId"] = [TLUser user].userId;
//    http.parameters[@"symbol"] = self.platform.symbol;
//    http.parameters[@"toSymbol"] = self.platform.toSymbol;
//    
//    [http postWithSuccess:^(id responseObject) {
//        
//        NSString *promptStr = [self.platform.isChoice isEqualToString:@"1"] ? @"删除自选成功": @"添加自选成功";
//        [TLAlert alertWithSucces:promptStr];
//        
//        if ([self.platform.isChoice isEqualToString:@"1"]) {
//            
//            self.platform.isChoice = @"0";
//            
//        } else {
//            
//            self.platform.isChoice = @"1";
//        }
//        
//        self.bottomView.platform = self.platform;
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"FollowOrCancelFollow" object:nil];
//        //刷新关注人数
//        [self followOrCancelFollow];
//        
//    } failure:^(NSError *error) {
//        
//    }];
//}

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
