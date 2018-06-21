//
//  MineCenterViewController.m
//  ljs
//
//  Created by shaojianfei on 2018/5/19.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MineCenterViewController.h"
#import "InfoManager.h"
//M
#import "NewsFlashModel.h"
#import "InfoTypeModel.h"
//V
#import "SelectScrollView.h"
#import "TopLabelUtil.h"
//C
#import "HomeChildVC.h"
#import "ArticleStateController.h"
#import "HomePageInfoVC.h"
#import "HomePageHeaderView.h"
@interface MineCenterViewController ()<SegmentDelegate>
//顶部切换
@property (nonatomic, strong) TopLabelUtil *labelUnil;
//大滚动
@property (nonatomic, strong) UIScrollView *switchSV;
@property (nonatomic, strong) HomePageHeaderView *headerView;

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

@implementation MineCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资讯";
    self.titles = [NSMutableArray arrayWithObjects:@"资讯", @"文章",@"活动", nil];
    [super viewDidLoad];
    [self addPushNotification];
    //顶部切换
    [self initSegmentView];
    
    // Do any additional setup after loading the view.
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
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = kImage(@"我的-背景");
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    imageView.tag = 1500;
    imageView.backgroundColor = kAppCustomMainColor;
    
    [self.view addSubview:imageView];
    self.headerView = [[HomePageHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    
    self.headerView.backgroundColor = kHexColor(@"#2E2E2E");
    [self.view addSubview:_headerView];
    
    //***********设置顶部条**************************
    NSArray *titleArr = @[@"我的资讯"];
    
    self.statusList = @[ kHotNewsFlash];
    self.titles = [NSMutableArray array];
    CGFloat h = 34;
    self.labelUnil = [[TopLabelUtil alloc]initWithFrame:CGRectMake(kScreenWidth/2 - kWidth(200), (44-h), kWidth(199), h)];
    
    self.labelUnil.delegate = self;
//    self.labelUnil.backgroundColor = kAppCustomMainColor;
//    self.labelUnil.titleNormalColor = kWhiteColor;
//    self.labelUnil.titleSelectColor = kWhiteColor;
    self.labelUnil.backgroundColor = kWhiteColor;
    self.labelUnil.titleNormalColor = kTextColor;
    self.labelUnil.titleSelectColor = kAppCustomMainColor;
    self.labelUnil.layer.borderColor = kLineColor.CGColor;
    self.labelUnil.titleFont = Font(18);
    self.labelUnil.lineType = LineTypeButtonLength;
    self.labelUnil.titleArray = titleArr;
    //    self.labelUnil.layer.cornerRadius = h/2.0;
    //    self.labelUnil.layer.borderWidth = 1;
    //    self.labelUnil.layer.borderColor = kWhiteColor.CGColor;
    self.labelUnil.userInteractionEnabled = NO;
    self.labelUnil.selectBtn.selected = YES;
    [self.labelUnil.selectBtn setBackgroundColor:kAppCustomMainColor forState:UIControlStateNormal];
    [self.labelUnil.selectBtn setBackgroundColor:kAppCustomMainColor forState:UIControlStateSelected];
    self.labelUnil .hidden = YES;
    
    
    self.navigationItem.titleView = self.labelUnil;
    //******************************************
    
    //1.切换背景
    self.switchSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 110, kScreenWidth, kSuperViewHeight)];
    [self.view addSubview:self.switchSV];
    [self.switchSV setContentSize:CGSizeMake(titleArr.count*self.switchSV.width, self.switchSV.height)];
    self.switchSV.scrollEnabled = NO;
    //    //2.订单列表
    NSArray *kindArr = @[ kInformation];
    for (int i = 0; i < titleArr.count; i++) {
        
        self.kind = kindArr[i];
        
        if ([self.kind isEqualToString:kInformation]) {
            
            self.titles = [NSMutableArray arrayWithObjects:@"动态", @"文章", nil];
            
            [self initSelectScrollView:i];
            
        } else {
            //查询资讯类型
            [self requestInfoTypeList];
        }
    }
    
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
        
        HomePageInfoVC *childVC = [[HomePageInfoVC alloc] init];
        childVC.IsCenter = YES;
        childVC.userId = [TLUser user].userId;
//        ArticleStateController *childVC = [[ArticleStateController alloc] init];
        //
        //        if ([self.kind isEqualToString:kNewsFlash]) {
        //
        //            childVC.status = self.statusList[i];
        //
        //        } else {
        
        childVC.code = self.infoTypeList[i].code;
        childVC.titleStr = self.titles[i];
        //        }
        childVC.kind = self.kind;
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight);
        
        [self addChildViewController:childVC];
        
        [selectSV.scrollView addSubview:childVC.view];
    }
    [self requestUserInfo];
    selectSV.selectBlock = ^(NSInteger index) {
        NSString * str = [NSString stringWithFormat:@"%ld",index];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"indexChange" object:@{@"str":str}];
    };
}

#pragma mark - Data
- (void)requestInfoTypeList {
    
    self.titles = [NSMutableArray arrayWithObjects:@"待审核", @"审核中",@"已通过", nil];
    [self initSelectScrollView:1];
    
}

/**
 获取用户信息
 */
- (void)requestUserInfo {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805121";
    
    if ([TLUser user].isLogin) {
        
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"token"] = [TLUser user].token;
        
    } else {
        
        http.parameters[@"userId"] = @"";
        http.parameters[@"token"] = @"";
        
    }
    [http postWithSuccess:^(id responseObject) {
        
        NSString *photo = responseObject[@"data"][@"photo"];
        NSString *nickname = responseObject[@"data"][@"nickname"];
        //
        [self.headerView.userPhoto sd_setImageWithURL:[NSURL URLWithString:[photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
        
        [self.headerView.nameBtn setTitle:nickname forState:UIControlStateNormal];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - SegmentDelegate
- (void)segment:(TopLabelUtil *)segment didSelectIndex:(NSInteger)index {
    
    [self.switchSV setContentOffset:CGPointMake((index - 1) * self.switchSV.width, 0)];
    //    [self.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];
    
}


@end
