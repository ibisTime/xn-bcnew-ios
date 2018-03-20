//
//  InfoCommentDetailVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/20.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//
//Macro
//Framework
//Category
//Extension
#import <IQKeyboardManager.h>
//M
//V
#import "BaseView.h"
#import "InputTextView.h"
#import "InfoCommentDetailTableView.h"
//C

#define kBottomHeight 50

#import "InfoCommentDetailVC.h"

@interface InfoCommentDetailVC ()<InputTextViewDelegate, RefreshDelegate>
//评论
@property (nonatomic, strong) InfoCommentDetailTableView *tableView;
//底部
@property (nonatomic, strong) BaseView *bottomView;
//输入框
@property (nonatomic, strong) InputTextView *inputTV;
//commentList
@property (nonatomic, strong) NSArray <InfoCommentModel *>*comments;

@end

@implementation InfoCommentDetailVC

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
    self.title = @"评论详情";
    //评论
    [self initCommentTableView];
    //获取评论列表
    [self requestCommentList];
    //底部
    [self initBottomView];
}

#pragma mark - Init
- (InputTextView *)inputTV {
    
    if (!_inputTV) {
        
        _inputTV = [[InputTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _inputTV.delegate = self;
        
    }
    return _inputTV;
}

/**
 评论列表
 */
- (void)initCommentTableView {
    
    self.tableView = [[InfoCommentDetailTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
        make.bottom.equalTo(@(-kBottomHeight-kBottomInsetHeight));
    }];
   
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
    
    self.tableView.scrollEnabled = NO;
    [self.inputTV show];
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
    
    self.tableView.comments = self.comments;
    
    [self.tableView reloadData];
}

#pragma mark - InputTextViewDelegate
- (void)clickedSureBtnWithText:(NSString *)text {
    
}

- (void)clickedCancelBtn {
    
    self.tableView.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
