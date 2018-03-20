//
//  InfoDetailVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "InfoDetailVC.h"
//Macro
//Framework
//Category
//Extension
#import <IQKeyboardManager.h>
//M
//V
#import "BaseView.h"
#import "InformationDetailTableView.h"
#import "InformationDetailHeaderView.h"
#import "InputTextView.h"
//C
#import "InfoCommentDetailVC.h"

#define kBottomHeight 50

@interface InfoDetailVC ()<InputTextViewDelegate, RefreshDelegate>
//评论
@property (nonatomic, strong) InformationDetailTableView *tableView;
//头部
@property (nonatomic, strong) InformationDetailHeaderView *headerView;
//底部
@property (nonatomic, strong) BaseView *bottomView;
//infoList
@property (nonatomic, strong) NSArray <InformationModel *>*infos;
//commentList
@property (nonatomic, strong) NSArray <InfoCommentModel *>*comments;
//输入框
@property (nonatomic, strong) InputTextView *inputTV;

@end

@implementation InfoDetailVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //隐藏第三方键盘
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    //显示第三方键盘
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"资讯详情";
    //底部
    [self initBottomView];
    //评论
    [self initCommentTableView];
    //获取评论列表
    [self requestCommentList];
    //获取文章列表
    [self requestInfoList];
}

- (void)viewDidLayoutSubviews {
    
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - Init
- (InputTextView *)inputTV {
    
    if (!_inputTV) {
        
        _inputTV = [[InputTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _inputTV.delegate = self;
        
    }
    return _inputTV;
}

- (InformationDetailHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[InformationDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        
        _tableView.tableHeaderView = _headerView;
    }
    return _headerView;
}

/**
 评论列表
 */
- (void)initCommentTableView {
    
    self.tableView = [[InformationDetailTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
        make.bottom.equalTo(@(-kBottomHeight-kBottomInsetHeight));
    }];
    
    //头部
    self.headerView = [[InformationDetailHeaderView alloc] init];
    
    self.headerView.backgroundColor = kWhiteColor;
    self.headerView.infoModel = self.infoModel;
    
    self.tableView.tableHeaderView = self.headerView;
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
    //分享
    UIButton *shareBtn = [UIButton buttonWithImageName:@"分享"];
    
    [shareBtn addTarget:self action:@selector(shareInformation) forControlEvents:UIControlEventTouchUpInside];
    
    shareBtn.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.bottomView addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@20);
    }];
    //收藏
    UIButton *collectionBtn = [UIButton buttonWithImageName:@"未收藏" selectedImageName:@"收藏"];
    
    [collectionBtn addTarget:self action:@selector(collectionInformation) forControlEvents:UIControlEventTouchUpInside];
    collectionBtn.contentMode = UIViewContentModeScaleAspectFit;

    [self.bottomView addSubview:collectionBtn];
    [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(shareBtn.mas_left).offset(-15);
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@20);
    }];
    //评论数
    UIButton *commentNumBtn = [UIButton buttonWithImageName:@"未留言" selectedImageName:@"留言"];
    
    commentNumBtn.contentMode = UIViewContentModeScaleAspectFit;

    [self.bottomView addSubview:commentNumBtn];
    
    [commentNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(collectionBtn.mas_left).offset(-15);
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@20);
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
        make.right.equalTo(commentNumBtn.mas_left).offset(-15);
    }];
    
    [commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, kWidth(-100), 0, 0)];
}

#pragma mark - Events

/**
 分享资讯
 */
- (void)shareInformation {
    
    
}

/**
 收藏资讯
 */
- (void)collectionInformation {
    
    
}

/**
 去占沙发
 */
- (void)clickComment {
    
    self.tableView.scrollEnabled = NO;
    [self.inputTV show];
}

#pragma mark - Data
- (void)requestInfoList {
    
    NSMutableArray <InformationModel *>*arr = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        
        InformationModel *model = [InformationModel new];
        
        model.title = @"但也仅仅事关你艺术造诣上的突破，艺考这点事，犯不上每个人都得动用自己的天赋。艺考这东西已经体制化，僵硬化了用自己的天赋。艺考这东用自己的天赋。";
        model.time = @"May 1, 2018 3:27:08 AM";
        model.collectNum = 99;
        model.author = @"CzyGod";
        model.source = @"知乎";
        model.desc = @"但也仅仅事关你艺术造诣上的突破，艺考这点事，犯不上每个人都得动用自己的天赋。艺考这东西已经体制化，僵硬化了用自己的天赋。艺考这东用自己的天赋。";
        
        [arr addObject:model];
    }
    
    self.infos = arr;
    
    self.tableView.infos = self.infos;
    
    [self.tableView reloadData];

}

- (void)requestCommentList {
    
    NSMutableArray <InfoCommentModel *>*arr = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        
        InfoCommentModel *model = [InfoCommentModel new];
        
        model.photo = @"";
        model.commentDatetime = @"May 1, 2018 3:27:08 AM";
        model.nickname = @"CzyGod";
        model.zanNum = 99;
        model.content = @"但也仅仅事关你艺术造诣上的突破，艺考这点事，犯不上每个人都得动用自己的天赋。艺考这东西已经体制化，僵硬化了用自己的天赋。艺考这东用自己的天赋。";
        model.isZan = YES;
        
        [arr addObject:model];
    }
    
    self.comments = arr;
    
    self.tableView.hotComments = self.comments;
    self.tableView.newestComments = self.comments;

    [self.tableView reloadData];
}

#pragma mark - InputTextViewDelegate
- (void)clickedSureBtnWithText:(NSString *)text {
    
}

- (void)clickedCancelBtn {
    
    self.tableView.scrollEnabled = YES;
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InfoCommentDetailVC *detailVC = [InfoCommentDetailVC new];
    
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
