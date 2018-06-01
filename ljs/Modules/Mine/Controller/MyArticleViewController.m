//
//  MyArticleViewController.m
//  ljs
//
//  Created by shaojianfei on 2018/5/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MyArticleViewController.h"
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
@interface MyArticleViewController ()<SegmentDelegate>
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

@implementation MyArticleViewController

- (void)viewDidLoad {
    self.title = @"我的资讯";
    self.titles = [NSMutableArray arrayWithObjects:@"待审核", @"审核中",@"已通过", nil];
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
    
    
    //***********设置顶部条**************************
    NSArray *titleArr = @[@"我的文章"];
    
    self.statusList = @[ kHotNewsFlash];
    self.titles = [NSMutableArray array];
    CGFloat h = 34;
    self.labelUnil = [[TopLabelUtil alloc]initWithFrame:CGRectMake(kScreenWidth/2 - kWidth(200), (44-h), kWidth(199), h)];
    
    self.labelUnil.delegate = self;
    self.labelUnil.backgroundColor = kAppCustomMainColor;
    self.labelUnil.titleNormalColor = kWhiteColor;
    self.labelUnil.titleSelectColor = kWhiteColor;
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
    
    
    self.navigationItem.titleView = self.labelUnil;
    //******************************************
    
    //1.切换背景
    self.switchSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    [self.view addSubview:self.switchSV];
    [self.switchSV setContentSize:CGSizeMake(titleArr.count*self.switchSV.width, self.switchSV.height)];
    self.switchSV.scrollEnabled = NO;
//    //2.订单列表
    NSArray *kindArr = @[ kInformation];
    for (int i = 0; i < titleArr.count; i++) {
        
        self.kind = kindArr[i];
        
        if ([self.kind isEqualToString:kInformation]) {
            
            self.titles = [NSMutableArray arrayWithObjects:@"待审核", @"审核中",@"已通过", nil];
            
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
        
        ArticleStateController *childVC = [[ArticleStateController alloc] init];
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
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight  - kTabBarHeight);
        
        [self addChildViewController:childVC];
        
        [selectSV.scrollView addSubview:childVC.view];
    }
    
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

#pragma mark - SegmentDelegate
- (void)segment:(TopLabelUtil *)segment didSelectIndex:(NSInteger)index {
    NSString * str = [NSString stringWithFormat:@"%ld",index];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"indexChange" object:@{@"str":str}];

    [self.switchSV setContentOffset:CGPointMake((index - 1) * self.switchSV.width, 0)];
//    [self.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];
    
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
