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
//M
#import "NewsFlashModel.h"
#import "InfoTypeModel.h"
//V
#import "SelectScrollView.h"
#import "TopLabelUtil.h"
#import "UIBarButtonItem+convience.h"
//C
#import "HomeChildVC.h"
#import "NewSearchViewController.h"
#import "NavigationController.h"
@interface HomeVC ()<SegmentDelegate>
//顶部切换
@property (nonatomic, strong) TopLabelUtil *labelUnil;
//大滚动
@property (nonatomic, strong) UIScrollView *switchSV;
//小滚动
@property (nonatomic, strong) SelectScrollView *selectSV;
//titles
@property (nonatomic, strong) NSMutableArray *titles;
//statusList
@property (nonatomic, strong) NSArray *statusList;
//类型
@property (nonatomic, copy) NSString *kind;
//资讯类型
@property (nonatomic, strong) NSArray <InfoTypeModel *>*infoTypeList;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //监听推送
    [self addPushNotification];
    //顶部切换
    [self initSegmentView];
    
}

#pragma mark - Notification
- (void)addPushNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeSelect)
                                                 name:@"DidReceivePushNotification"
                                               object:nil];
}

- (void)changeSelect {
    
    //切换到热点界面
    SelectScrollView *selectSV = (SelectScrollView *)[self.view viewWithTag:2500];
    
    selectSV.currentIndex = 1;
}

#pragma mark - Init
- (void)initSegmentView {
    
    
//***********设置顶部条**************************
    NSArray *titleArr = @[@"资讯",
                          @"快讯"
                          ];
    
    self.statusList = @[kAllNewsFlash, kHotNewsFlash];
    self.titles = [NSMutableArray array];
    CGFloat h = 34;
    self.labelUnil = [[TopLabelUtil alloc]initWithFrame:CGRectMake(kScreenWidth/2 - kWidth(200), (44-h), kWidth(199), h)];
    
    self.labelUnil.delegate = self;
//    self.labelUnil.backgroundColor = [UIColor clearColor];
//    self.labelUnil.titleNormalColor = kWhiteColor;
//    self.labelUnil.titleSelectColor = kAppCustomMainColor;
    self.labelUnil.titleFont = Font(18);
    self.labelUnil.lineType = LineTypeButtonLength;
    self.labelUnil.titleArray = titleArr;
    self.labelUnil.layer.cornerRadius = h/2.0;
    self.labelUnil.layer.borderWidth = 1;
//    self.labelUnil.layer.borderColor = kWhiteColor.CGColor;
    self.labelUnil.backgroundColor = kWhiteColor;
    self.labelUnil.titleNormalColor = kTextColor2;
    self.labelUnil.titleSelectColor = kAppCustomMainColor;
    self.labelUnil.layer.borderColor = kLineColor.CGColor;
    self.navigationItem.titleView = self.labelUnil;
    //******************************************
    
    //1.切换背景
    self.switchSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    [self.view addSubview:self.switchSV];
    [self.switchSV setContentSize:CGSizeMake(titleArr.count*self.switchSV.width, self.switchSV.height)];
    self.switchSV.scrollEnabled = NO;
    //2.订单列表
    NSArray *kindArr = @[kInformation ,kNewsFlash];
    
    self.titles = [NSMutableArray arrayWithObjects:@"全部", @"热点", nil];
    [self initSelectScrollView:1];
    self.kind = kNewsFlash;
    
    [self requestInfoTypeList];
    [UIBarButtonItem addRightItemWithImageName:@"搜索" frame:CGRectMake(0, 0, 40, 40) vc:self action:@selector(search)];
    
//    for (int i = 0; i < titleArr.count; i++) {
//
//        self.kind = kindArr[i];
//
//        if ([self.kind isEqualToString:kNewsFlash]) {
//
//            self.titles = [NSMutableArray arrayWithObjects:@"全部", @"热点", nil];
//
//            [self initSelectScrollView:i];
//
//        } else {
//            //查询资讯类型
//            [self requestInfoTypeList];
//        }
//    }
}

- (void)search {
    
    BaseWeakSelf;
    
    NewSearchViewController *searchVC = [NewSearchViewController new];
    
    //    searchVC.currencyBlock = ^{
    //
    //        [weakSelf.tableView beginRefreshing];
    //    };
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:searchVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)initSelectScrollView:(NSInteger)index {
    
    SelectScrollView *selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(index*kScreenWidth, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) itemTitles:self.titles];
    
    selectSV.tag = 2500 + index;
    
    [self.switchSV addSubview:selectSV];
    
    [self addSubViewController:index];
}

- (void)addSubViewController:(NSInteger)index {
    
    SelectScrollView *selectSV = (SelectScrollView *)[self.view viewWithTag:2500+index];

    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        HomeChildVC *childVC = [[HomeChildVC alloc] init];
        
        if (index == 1) {
        
            childVC.status = self.statusList[i];
            childVC.kind = @"1";

        } else {
            
            childVC.code = self.infoTypeList[i].code;
            childVC.titleStr = self.titles[i];
            childVC.kind = @"2";
            
            if (i == 0) {
                childVC.isActivity = YES;
            }

        }
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight);
        
        [self addChildViewController:childVC];
        
        [selectSV.scrollView addSubview:childVC.view];
    }
}

#pragma mark - Data
- (void)requestInfoTypeList {
    //根据返回来的名称设置子标题
    //请求
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628007";
    
    //解析
    [http postWithSuccess:^(id responseObject) {
        
        //字典转模型
        self.infoTypeList = [InfoTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        self.titles = [NSMutableArray array];
        
       
        [self.infoTypeList enumerateObjectsUsingBlock:^(InfoTypeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self.titles addObject:obj.name];
        }];
        
        
        [self initSelectScrollView:0];
      
        
    } failure:^(NSError *error) {
        
    }];
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
