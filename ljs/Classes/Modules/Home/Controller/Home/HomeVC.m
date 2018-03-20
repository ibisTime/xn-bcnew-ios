//
//  HomeVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HomeVC.h"
//Manager
#import "InfoManager.h"
//V
#import "SelectScrollView.h"
#import "TopLabelUtil.h"
//C
#import "HomeChildVC.h"

@interface HomeVC ()<SegmentDelegate>
//顶部切换
@property (nonatomic, strong) TopLabelUtil *labelUnil;
//大滚动
@property (nonatomic, strong) UIScrollView *switchSV;
//小滚动
@property (nonatomic, strong) SelectScrollView *selectSV;
//titles
@property (nonatomic, strong) NSArray *titles;
//statusList
@property (nonatomic, strong) NSArray *statusList;
//类型
@property (nonatomic, copy) NSString *kind;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //顶部切换
    [self initSegmentView];
}

#pragma mark - Init
- (void)initSegmentView {
    
    NSArray *titleArr = @[
                          @"快讯",
                          @"资讯"];
    
    CGFloat h = 34;
    
    self.labelUnil = [[TopLabelUtil alloc]initWithFrame:CGRectMake(kScreenWidth/2 - kWidth(200), (44-h), kWidth(199), h)];
    
    self.labelUnil.delegate = self;
    self.labelUnil.backgroundColor = [UIColor clearColor];
    self.labelUnil.titleNormalColor = kWhiteColor;
    self.labelUnil.titleSelectColor = kAppCustomMainColor;
    self.labelUnil.titleFont = Font(18);
    self.labelUnil.lineType = LineTypeButtonLength;
    self.labelUnil.titleArray = titleArr;
    self.labelUnil.layer.cornerRadius = h/2.0;
    self.labelUnil.layer.borderWidth = 1;
    self.labelUnil.layer.borderColor = kWhiteColor.CGColor;
    
    self.navigationItem.titleView = self.labelUnil;
    
    //1.切换背景
    self.switchSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    [self.view addSubview:self.switchSV];
    [self.switchSV setContentSize:CGSizeMake(titleArr.count*self.switchSV.width, self.switchSV.height)];
    self.switchSV.scrollEnabled = NO;
    //2.订单列表
    NSArray *kindArr = @[kNewsFlash, kInformation];
    
    for (int i = 0; i < titleArr.count; i++) {
        
        self.kind = kindArr[i];
        
        if ([self.kind isEqualToString:kNewsFlash]) {
            
            self.titles = @[@"全部", @"热点"];
            
        } else {
            
            self.titles = @[@"实时新闻", @"热点头条", @"行情分析", @"币圈杂谈", @"名家论事"];
        }
        
        SelectScrollView *selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) itemTitles:self.titles];
        
        [self.switchSV addSubview:selectSV];
        
        self.selectSV = selectSV;
        
        [self addSubViewController];
    }
    
}

- (void)addSubViewController {
    
    if ([self.kind isEqualToString:kNewsFlash]) {
        
//        self.statusList = @[@"", kAppointmentOrderStatusWillCheck, kAppointmentOrderStatusWillVisit, kAppointmentOrderStatusWillOverClass, kAppointmentOrderStatusDidOverClass, kAppointmentOrderStatusDidComplete];
        
    } else {
        
//        self.statusList = @[@"", kAppointmentOrderStatusWillCheck, kAppointmentOrderStatusWillVisit, kAppointmentOrderStatusWillOverClass, kAppointmentOrderStatusDidComplete];
    }
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        HomeChildVC *childVC = [[HomeChildVC alloc] init];
        
//        childVC.status = self.statusList[i];
        childVC.kind = self.kind;
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight);
        
        [self addChildViewController:childVC];
        
        [self.selectSV.scrollView addSubview:childVC.view];
        
    }
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
