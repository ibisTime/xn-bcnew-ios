//
//  ForumDetailVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumDetailVC.h"
//Category
#import <UIScrollView+TLAdd.h>
//Extension
#import <IQKeyboardManager.h>
//M
#import "ForumDetailModel.h"
//V
#import "SelectScrollView.h"
#import "ForumCircleTableView.h"
#import "TLTableView.h"
#import "ForumDetailTableView.h"
#import "ForumDetailHeaderView.h"
#import "InputTextView.h"

#import "ForumQuotesTableView.h"
//C
#import "ForumCircleChildVC.h"
#import "ForumInfoChildVC.h"
#import "ForumQuotesChildVC.h"

#define kBottomHeight 50

@interface ForumDetailVC ()<UIScrollViewDelegate, InputTextViewDelegate, UITableViewDelegate>
//
@property (nonatomic, strong) ForumDetailHeaderView *headerView;
//
@property (nonatomic, strong) ForumDetailTableView *tableView;
//
@property (nonatomic, strong) SelectScrollView *selectScrollView;
//标题
@property (nonatomic, strong) NSArray *titles;
//
@property (nonatomic, assign) BOOL canScroll;
//vcCanScroll
@property (nonatomic, assign) BOOL vcCanScroll;
//
@property (nonatomic, strong) ForumDetailModel *detailModel;
//底部
@property (nonatomic, strong) BaseView *bottomView;
//输入框
@property (nonatomic, strong) InputTextView *inputTV;

@end

@implementation ForumDetailVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //隐藏第三方键盘
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    //显示第三方键盘
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"币吧";
    //币种信息
    [self initTableView];
    //底部输入框
    [self initBottomView];
    //圈子、资讯和行情
    [self initSelectScrollView];
    //详情
    [self requestForumDetail];
    //添加下拉刷新
    [self addDownRefresh];
    //添加通知
    [self addNotification];
    
}

#pragma mark - 通知
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCLeaveTop) name:@"SubVCLeaveTop" object:nil];
    //发布帖子刷新界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestForumDetail) name:@"RefreshCommentList" object:nil];
}

- (void)subVCLeaveTop {
    
    self.canScroll = YES;
    self.vcCanScroll = NO;
}

/**
 刷新今日跟帖数
 */
- (void)refreshCommentCount {
    
    NSString *code = self.type == ForumEntrancetypeQuotes ? @"628239": @"628238";
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = code;
    if (self.type == ForumEntrancetypeQuotes) {
        
        http.parameters[@"toCoin"] = self.toCoin;
        
    } else {
        
        http.parameters[@"code"] = self.code;
    }
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.detailModel = [ForumDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.headerView.detailModel = self.detailModel;
        self.tableView.tableHeaderView = self.headerView;
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 下拉刷新
- (void)addDownRefresh {
    
    BaseWeakSelf;
    
    [self.tableView addRefreshAction:^{
        
        //详情
        [weakSelf requestForumDetail];
        //
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshForumDetail" object:nil];
    }];
    
}

#pragma mark - 评论弹窗
- (InputTextView *)inputTV {
    
    if (!_inputTV) {
        
        _inputTV = [[InputTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _inputTV.delegate = self;
        
    }
    return _inputTV;
}

#pragma mark - Init

- (void)initTableView {

    BaseWeakSelf;
    
    self.canScroll = YES;

    self.tableView = [[ForumDetailTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kBottomHeight - kBottomInsetHeight) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    //Header
    self.headerView = [[ForumDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    
    self.headerView.refreshHeaderBlock = ^{
        
        weakSelf.tableView.tableHeaderView = weakSelf.headerView;
    };
    
    self.headerView.backgroundColor = kWhiteColor;
}

- (void)initSelectScrollView {
    
    BaseWeakSelf;
    
    self.titles = @[@"圈子", @"资讯", @"行情"];
    
    self.selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, kSuperViewHeight - kBottomHeight - kBottomInsetHeight) itemTitles:self.titles];
    
    self.selectScrollView.selectBlock = ^(NSInteger index) {
        
        [weakSelf didSelectWithIndex:index];
    };
    
    self.tableView.tableFooterView = self.selectScrollView;
    
}

/**
 切换标签
 */
- (void)didSelectWithIndex:(NSInteger)index {
    
    self.bottomView.hidden = index == 0 ? NO: YES;
    //圈子
    if (index == 0) {
        
        self.selectScrollView.height = kSuperViewHeight - kBottomHeight - kBottomInsetHeight;
        self.tableView.height = self.selectScrollView.height;
        self.tableView.tableFooterView = self.selectScrollView;
        
    } else {
        
        self.selectScrollView.height = kSuperViewHeight;
        self.tableView.height = kSuperViewHeight;
        self.tableView.tableFooterView = self.selectScrollView;
    }
}

- (void)addSubViewController {
    
    BaseWeakSelf;
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        if (i == 0) {
            
            ForumCircleChildVC *childVC = [[ForumCircleChildVC alloc] init];
            
            childVC.refreshSuccess = ^{
                
                [weakSelf.tableView endRefreshHeader];
            };
            childVC.index = i;
            childVC.detailModel = self.detailModel;
            
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, self.selectScrollView.height - 40);
            
            [self addChildViewController:childVC];
            
            [_selectScrollView.scrollView addSubview:childVC.view];
            
        } else if (i == 1) {
            
            ForumInfoChildVC *childVC = [[ForumInfoChildVC alloc] init];
            
            childVC.refreshSuccess = ^{
                
                [weakSelf.tableView endRefreshHeader];
            };
            childVC.index = i;
            childVC.toCoin = self.detailModel.code;
            
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
            
            [self addChildViewController:childVC];
            
            [_selectScrollView.scrollView addSubview:childVC.view];
            
        } else {
            
            ForumQuotesChildVC *childVC = [[ForumQuotesChildVC alloc] init];
            
            childVC.refreshSuccess = ^{
                
                [weakSelf.tableView endRefreshHeader];
            };
            childVC.index = i;
            //detailModel不为空则是币种
            childVC.type = self.detailModel.coin ? ForumQuotesTypeCurrency: ForumQuotesTypePlatform;
            childVC.toCoin = self.detailModel.toCoin;
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
            
            [self addChildViewController:childVC];
            
            [_selectScrollView.scrollView addSubview:childVC.view];
            
        }
    }
    
    //转移手势
    ForumCircleTableView *tableView = (ForumCircleTableView *)[self.view viewWithTag:1800];

    UIPanGestureRecognizer *panGR = tableView.panGestureRecognizer;

    [self.tableView addGestureRecognizer:panGR];

    self.tableView.contentSize = CGSizeMake(kScreenWidth, self.selectScrollView.yy+10000);
}


- (void)initBottomView {
    
    self.bottomView = [[BaseView alloc] initWithFrame:CGRectMake(0, kSuperViewHeight - kBottomHeight - kBottomInsetHeight, kScreenWidth, kBottomHeight)];
    
    self.bottomView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:self.bottomView];
    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kLineColor;
    
    [self.bottomView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    //点击评论
    UIButton *commentBtn = [UIButton buttonWithTitle:@"说出你的看法"
                                          titleColor:kHexColor(@"#9E9E9E")
                                     backgroundColor:kHexColor(@"E5E5E5")
                                           titleFont:12.0
                                        cornerRadius:17.5];
    
    [commentBtn addTarget:self action:@selector(clickComment) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:commentBtn];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.height.equalTo(@35);
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-15));
    }];
    
}

#pragma mark - Events
/**
 去占沙发
 */
- (void)clickComment {
    
    BaseWeakSelf;
    
    [self checkLogin:^{
        
        weakSelf.tableView.scrollEnabled = NO;
        
        [weakSelf.inputTV show];
    }];
}

#pragma mark - Data
/**
 详情
 */
- (void)requestForumDetail {
    
    NSString *code = self.type == ForumEntrancetypeQuotes ? @"628239": @"628238";
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = code;
    if (self.type == ForumEntrancetypeQuotes) {
        
        http.parameters[@"toCoin"] = self.toCoin;

    } else {
        
        http.parameters[@"code"] = self.code;
    }
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.detailModel = [ForumDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.tableView.detailModel = self.detailModel;
        self.headerView.detailModel = self.detailModel;
        self.tableView.tableHeaderView = self.headerView;
        
        [self.tableView reloadData];
        //添加子控制器
        [self addSubViewController];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - InputTextViewDelegate
- (void)clickedSureBtnWithText:(NSString *)text {
    //type(1 资讯 2 评论)
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628650";
    http.parameters[@"plateCode"] = self.detailModel.code;
    http.parameters[@"content"] = text;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        //评论完成，清空内容
        self.inputTV.commentTV.text = @"";
        
        NSString *code = responseObject[@"data"][@"code"];
        
        if ([code containsString:@"approve"]) {
            
            [TLAlert alertWithInfo:[NSString stringWithFormat:@"发布成功, 您的评论包含敏感字符,我们将进行审核"]];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            return ;
        }
        
        [TLAlert alertWithSucces:[NSString stringWithFormat:@"%@成功", @"发布"]];
        
        self.tableView.scrollEnabled = YES;
        //刷新圈子的评论列表
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCommentList" object:nil];
        
    } failure:^(NSError *error) {
        
        self.tableView.scrollEnabled = YES;

    }];
}

- (void)clickedCancelBtn {
    
    self.tableView.scrollEnabled = YES;
}
#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat bottomOffset = self.selectScrollView.y;
    
    CGFloat scrollOffset = scrollView.contentOffset.y;
    
    //子视图已经到顶部
    if (
        scrollOffset >= bottomOffset) {
        
        //当视图到达顶部时，使视图悬停
        scrollView.contentOffset = CGPointMake(0, bottomOffset);
        
        if (self.canScroll) {
            
            self.canScroll = NO;
            self.vcCanScroll = YES;
        }
        //转移手势
        TLTableView *tableView = (TLTableView *)[self.view viewWithTag:1800+self.selectScrollView.selectIndex];
        
        UIPanGestureRecognizer *panGR = tableView.panGestureRecognizer;
        
        [scrollView addGestureRecognizer:panGR];
        
    } else {
        
        //处理tableview和scrollView同时滚的问题（当vc不能滚动时，设置scrollView悬停）
        if (!self.canScroll) {
            
            scrollView.contentOffset = CGPointMake(0, bottomOffset);
        }
    }
    
    self.tableView.showsVerticalScrollIndicator = _canScroll ? YES: NO;
}

- (void)setVcCanScroll:(BOOL)vcCanScroll {
    
    for (ForumCircleChildVC *vc in self.childViewControllers) {
        
        vc.vcCanScroll = vcCanScroll;
    }
    
    for (ForumInfoChildVC *vc in self.childViewControllers) {
        
        vc.vcCanScroll = vcCanScroll;
    }
    
    for (ForumQuotesChildVC *vc in self.childViewControllers) {
        
        vc.vcCanScroll = vcCanScroll;
    }
}


/**
 VC被释放时移除通知
 */
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
