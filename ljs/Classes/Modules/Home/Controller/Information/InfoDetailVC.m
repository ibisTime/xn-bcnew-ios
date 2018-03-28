//
//  InfoDetailVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "InfoDetailVC.h"
//Manager
#import "TLWXManager.h"
#import "QQManager.h"
//Macro
#import "APICodeMacro.h"
//Framework
//Category
#import "TLProgressHUD.h"
//Extension
#import <IQKeyboardManager.h>
#import <TFHpple.h>
//M
#import "InfoDetailModel.h"
#import "InfoCommentModel.h"
//V
#import "BaseView.h"
#import "InformationDetailTableView.h"
#import "InformationDetailHeaderView.h"
#import "InputTextView.h"
#import "InfoDetailShareView.h"
//C
#import "InfoCommentDetailVC.h"
#import "NavigationController.h"
#import "TLUserLoginVC.h"

#define kBottomHeight 50

@interface InfoDetailVC ()<InputTextViewDelegate, RefreshDelegate>
//评论
@property (nonatomic, strong) InformationDetailTableView *tableView;
//头部
@property (nonatomic, strong) InformationDetailHeaderView *headerView;
//底部
@property (nonatomic, strong) BaseView *bottomView;
//infoList
@property (nonatomic, strong) InfoDetailModel *detailModel;
//commentList
@property (nonatomic, strong) NSArray <InfoCommentModel *>*comments;
@property (nonatomic, strong) TLPageDataHelper *helper;
//输入框
@property (nonatomic, strong) InputTextView *inputTV;
//收藏
@property (nonatomic, strong) UIButton *collectionBtn;
//分享链接
@property (nonatomic, copy) NSString *shareUrl;
//分享
@property (nonatomic, strong) InfoDetailShareView *shareView;
//留言数
@property (nonatomic, strong) UILabel *commentNumLbl;

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
    //评论
    [self initCommentTableView];
    //详情查资讯
    [self requestInfoDetail];
    //
    [self addNotification];
    //添加下拉刷新
    [self addDownRefresh];
    
}

#pragma mark - Init

/**
 输入框
 */
- (InputTextView *)inputTV {
    
    if (!_inputTV) {
        
        _inputTV = [[InputTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _inputTV.delegate = self;
        
    }
    return _inputTV;
}

- (InformationDetailHeaderView *)headerView {
    
    if (!_headerView) {
        
        BaseWeakSelf;
        
        _headerView = [[InformationDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        
        _headerView.shareBlock = ^(InfoShareType type) {
            
            [weakSelf shareWithType:type];
        };
        
        _headerView.backgroundColor = kWhiteColor;

    }
    return _headerView;
}

- (InfoDetailShareView *)shareView {
    
    if (!_shareView) {
        
        BaseWeakSelf;

        _shareView = [[InfoDetailShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _shareView.shareBlock = ^(ThirdType type) {
            
            [weakSelf shareEventsWithType:type];
        };
    }
    return _shareView;
}

- (void)addDownRefresh {
    
    BaseWeakSelf;
    
    [self.tableView addRefreshAction:^{
        
        //详情查资讯
        [weakSelf requestInfoDetail];
        //刷新评论
        [weakSelf refreshCommentList];
    }];
}
/**
 评论列表
 */
- (void)initCommentTableView {
    
    self.tableView = [[InformationDetailTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无评论"];
    
    self.tableView.refreshDelegate = self;
    
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
    //分享
    UIButton *shareBtn = [UIButton buttonWithImageName:@"分享"];
    
    [shareBtn addTarget:self action:@selector(shareInfo) forControlEvents:UIControlEventTouchUpInside];
    
    shareBtn.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.bottomView addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@20);
    }];
    //收藏
    UIButton *collectionBtn = [UIButton buttonWithImageName:@"未收藏"];
    
    NSString *image = [self.detailModel.isCollect isEqualToString:@"1"] ? @"收藏": @"未收藏";
    
    [collectionBtn setImage:kImage(image) forState:UIControlStateNormal];
    
    [collectionBtn addTarget:self action:@selector(collectionInfo:) forControlEvents:UIControlEventTouchUpInside];
    collectionBtn.contentMode = UIViewContentModeScaleAspectFit;

    [self.bottomView addSubview:collectionBtn];
    [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(shareBtn.mas_left).offset(-15);
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@20);
    }];
    
    self.collectionBtn = collectionBtn;
    
    //评论数
    UIButton *commentNumBtn = [UIButton buttonWithImageName:@"留言"];
    
    commentNumBtn.contentMode = UIViewContentModeScaleAspectFit;

    [self.bottomView addSubview:commentNumBtn];
    
    [commentNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(collectionBtn.mas_left).offset(-15);
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@20);
    }];
    
    self.commentNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kThemeColor
                                                      font:9.0];
    
    self.commentNumLbl.text = [NSString stringWithFormat:@"%ld", self.detailModel.commentCount];

    [self.bottomView addSubview:self.commentNumLbl];
    [self.commentNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(commentNumBtn.mas_top).offset(-1);
        make.centerX.equalTo(commentNumBtn.mas_right).offset(-5);
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

#pragma mark - 通知
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHeaderView) name:@"HeaderViewDidLayout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCommentList) name:@"RefreshCommentList" object:nil];
}

/**
 刷新headerView
 */
- (void)reloadHeaderView {
    
    self.tableView.tableHeaderView = self.headerView;
    //刷新
    [self.tableView reloadData];
    //底部按钮
    [self initBottomView];
    
    [TLProgressHUD dismiss];
}

#pragma mark - Events

/**
 分享资讯
 */
- (void)shareInfo {
    
    [self.shareView show];
}
/**
 分享
 */
- (void)shareWithType:(InfoShareType)type {
    
    NSString *desc = [self substringFromArticleContent:self.detailModel.content];

    switch (type) {
        case InfoShareTypeWechat:
        {
            [TLWXManager wxShareWebPageWithScene:WXSceneSession
                                           title:self.detailModel.title
                                            desc:desc
                                             url:self.shareUrl];
        }break;
            
        case InfoShareTypeTimeline:
        {
            [TLWXManager wxShareWebPageWithScene:WXSceneSession
                                           title:self.detailModel.title
                                            desc:desc
                                             url:self.shareUrl];
        }break;
            
        default:
            break;
    }
}

/**
 收藏资讯
 */
- (void)collectionInfo:(UIButton *)sender {
    
    BaseWeakSelf;
    
    [self checkLogin:^{
        
        TLNetworking *http = [TLNetworking new];
        
        http.code = @"628202";
        http.showView = self.view;
        http.parameters[@"objectCode"] = weakSelf.code;
        http.parameters[@"userId"] = [TLUser user].userId;
        
        [http postWithSuccess:^(id responseObject) {
            
            NSString *image = [weakSelf.detailModel.isCollect isEqualToString:@"1"] ? @"未收藏": @"收藏";
            NSString *promptStr = [weakSelf.detailModel.isCollect isEqualToString:@"1"] ? @"取消收藏成功": @"收藏成功";
            [TLAlert alertWithSucces:promptStr];
            [sender setImage:kImage(image) forState:UIControlStateNormal];
            
            weakSelf.detailModel.isCollect = [self.detailModel.isCollect isEqualToString:@"1"] ? @"0": @"1";
            
            if (self.collectionBlock) {
                
                self.collectionBlock();
            }
            
        } failure:^(NSError *error) {
            
        }];
    }];
}

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

#pragma mark - 分享
- (void)shareEventsWithType:(ThirdType)type {
    
    NSString *previewImage;
    
    if (self.detailModel.pics.count > 0) {
        
       previewImage = [self.detailModel.pics[0] convertImageUrl];
    }
    
    NSString *desc = [self substringFromArticleContent:self.detailModel.content];
    
    switch (type) {
        case ThirdTypeWeChat:
        {
            [TLWXManager wxShareWebPageWithScene:WXSceneSession
                                           title:self.detailModel.title
                                            desc:desc
                                             url:self.shareUrl];
            [TLWXManager manager].wxShare = ^(BOOL isSuccess, int errorCode) {
                
                if (isSuccess) {
                    
                    [TLAlert alertWithSucces:@"分享成功"];
                } else {
                    
                    [TLAlert alertWithError:@"分享失败"];
                }
            };
            
        }break;
            
        case ThirdTypeTimeLine:
        {
            [TLWXManager wxShareWebPageWithScene:WXSceneSession
                                           title:self.detailModel.title
                                            desc:desc
                                             url:self.shareUrl];
            [TLWXManager manager].wxShare = ^(BOOL isSuccess, int errorCode) {
                
                if (isSuccess) {
                    
                    [TLAlert alertWithSucces:@"分享成功"];
                } else {
                    
                    [TLAlert alertWithError:@"分享失败"];
                }
            };
            
        }break;
            
        case ThirdTypeQQ:
        {
            [QQManager manager].qqShare = ^(BOOL isSuccess, int errorCode) {
                
                if (isSuccess) {
                    
                    [TLAlert alertWithSucces:@"分享成功"];
                }else {
                    
                    [TLAlert alertWithSucces:@"分享失败"];
                }
            };
            
            [QQManager qqShareWebPageWithScene:0
                                         title:self.detailModel.title
                                          desc:desc
                                           url:self.shareUrl
                                  previewImage:previewImage];
            
        }break;
            
        case ThirdTypeWeiBo:
        {
            
        }break;
            
        default:
            break;
    }
}

/**
 截取文章内容
 @param content 文章内容
 @return 截取后的内容
 */
- (NSString *)substringFromArticleContent:(NSString *)content {
    
    //截取富文本的内容
    NSData *htmlData = [self.detailModel.content dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    NSArray *classArr = [hpple searchWithXPathQuery:@"//div"];
    
    NSMutableString *string = [NSMutableString string];
    
    for (TFHppleElement *element in classArr) {
        
        if (element.content) {
            
            [string add:element.content];
        }
    }
    //文章描述
//    NSString *desc = [string substringToIndex:50];
    
    return @"";
}

#pragma mark - Data
- (void)requestInfoDetail {
    
    [TLProgressHUD show];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628206";
    
    http.parameters[@"code"] = self.code;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.detailModel = [InfoDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
        //titleStr不存在就用typename
        if (!self.titleStr) {
            
            self.title = self.detailModel.typeName;
        }
        
        self.headerView.detailModel = self.detailModel;

        //获取最新评论列表
        [self requestCommentList];
        //获取分享链接
        [self getShareUrl];
        
    } failure:^(NSError *error) {
        
        [TLProgressHUD dismiss];
    }];
    
}

- (void)requestCommentList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628285";
    helper.parameters[@"objectCode"] = self.code;
    if ([TLUser user].userId) {
        
        helper.parameters[@"userId"] = [TLUser user].userId;
    }
    helper.tableView = self.tableView;
    self.helper = helper;
    
    [helper modelClass:[InfoCommentModel class]];
    
    [self refreshCommentList];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.comments = objs;
            
            weakSelf.tableView.newestComments = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

- (void)refreshCommentList {
    
    BaseWeakSelf;
    
    [self.helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.comments = objs;
        
        weakSelf.tableView.detailModel = weakSelf.detailModel;
        weakSelf.tableView.newestComments = objs;
        
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
    }];

}

- (void)getShareUrl {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_CKEY_CVALUE;
    http.parameters[@"ckey"] = @"h5ShareUrl";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.shareUrl = [NSString stringWithFormat:@"%@?code=%@", responseObject[@"data"][@"cvalue"], self.detailModel.code];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)zanCommentWithComment:(InfoCommentModel *)commentModel {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628201";
    http.showView = self.view;
    http.parameters[@"type"] = @"2";
    http.parameters[@"objectCode"] = commentModel.code;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *promptStr = [commentModel.isPoint isEqualToString:@"1"] ? @"取消点赞成功": @"点赞成功";
        [TLAlert alertWithSucces:promptStr];
        
        if ([commentModel.isPoint isEqualToString:@"1"]) {
            
            commentModel.isPoint = @"0";
            commentModel.pointCount -= 1;
            
        } else {
            
            commentModel.isPoint = @"1";
            commentModel.pointCount += 1;
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - InputTextViewDelegate
- (void)clickedSureBtnWithText:(NSString *)text {
    //type(1 资讯 2 评论)
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628200";
    http.parameters[@"type"] = @"1";
    http.parameters[@"objectCode"] = self.code;
    http.parameters[@"content"] = text;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *code = responseObject[@"data"][@"code"];
        
        if ([code containsString:@"approve"]) {
            
            [TLAlert alertWithInfo:[NSString stringWithFormat:@"发布成功, 您的评论包含敏感字符,我们将进行审核"]];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            return ;
        }
        
        [TLAlert alertWithSucces:[NSString stringWithFormat:@"%@成功", @"发布"]];
        
        self.tableView.scrollEnabled = YES;

        self.detailModel.commentCount += 1;
        
        self.commentNumLbl.text = [NSString stringWithFormat:@"%ld", self.detailModel.commentCount];
        //刷新评论
        [self refreshCommentList];
        
    } failure:^(NSError *error) {
        
        self.tableView.scrollEnabled = YES;

    }];
}

- (void)clickedCancelBtn {
    
    self.tableView.scrollEnabled = YES;
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //相关文章
    if (indexPath.section == 0) {
        
        InformationModel *infoModel = self.detailModel.refNewList[indexPath.row];

        InfoDetailVC *detailVC = [InfoDetailVC new];
        
        detailVC.code = infoModel.code;
        detailVC.title = self.titleStr;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        return ;
    }
    InfoCommentModel *commentModel = indexPath.section == 1 ? self.detailModel.hotCommentList[indexPath.row]: self.comments[indexPath.row];
    
    InfoCommentDetailVC *detailVC = [InfoCommentDetailVC new];
    
    detailVC.code = commentModel.code;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index {
    
    BaseWeakSelf;
    [self checkLogin:^{
        
        NSInteger section = index/1000;
        NSInteger row = index - section*1000;
        
        InfoCommentModel *commentModel = section == 1 ? weakSelf.detailModel.hotCommentList[row]: weakSelf.comments[row];
        
        [weakSelf zanCommentWithComment:commentModel];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
