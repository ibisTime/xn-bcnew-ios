//
//  ActivityCommentsVC.m
//  ljs
//
//  Created by apple on 2018/5/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ActivityCommentsVC.h"

//Macro
#import "APICodeMacro.h"
//Category
#import "TLProgressHUD.h"
//M
#import "ActivityCommentsM.h"
#import "InfoCommentModel.h"
//V
#import "BaseView.h"
#import "ActivityCommentsListV.h"
//C
#import "TLUserLoginVC.h"
#import "NavigationController.h"
#import "InfoCommentDetailVC.h"
#import "InputTextView.h"
#import "InfoCommentDetailTableView.h"
#import "InfoDetailModel.h"
#import "InfoAllCommentListTableView.h"
#import "ActivityNewsCommentView.h"
#import "ActivityNewSVC.h"
#define kBottomHeight 50
//#import "ac"
@interface ActivityCommentsVC ()<RefreshDelegate,InputTextViewDelegate>
//评论
@property (nonatomic, strong) ActivityNewsCommentView  *tableView;
//@property (nonatomic, strong) InfoCommentDetailTableView *tableView1;

//infoList
//@property (nonatomic, strong) InfoCommentModel *detailModel;
//infoList

@property (nonatomic, strong) InfoDetailModel * detailModel;
//commentList
@property (nonatomic, strong) NSArray <InfoCommentModel *>*comments;
@property (nonatomic, strong) TLPageDataHelper *helper;
@property (nonatomic, strong) BaseView *bottomView;
@property (nonatomic, strong) InputTextView *inputTV;
@property (nonatomic, strong) TLPlaceholderView *footerView;
//回复编号
@property (nonatomic, copy) NSString *replyCode;
//判断是评论还是回复
@property (nonatomic, assign) BOOL isComment;
@property (nonatomic, strong) InfoCommentModel *commentModel;
//
@end

@implementation ActivityCommentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动留言";
    //评论
    [self initCommentTableView];
//    [self initCommentTableView1];

    //详情查资讯
//    [self requestInfoDetail];
    //查询活动留言
    [self requestCommentList];
    //
    [self addNotification];
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
//    //分享
//    UIButton *shareBtn = [UIButton buttonWithImageName:@"分享"];
//
//    [shareBtn addTarget:self action:@selector(shareInfo) forControlEvents:UIControlEventTouchUpInside];
//
//    shareBtn.contentMode = UIViewContentModeScaleAspectFit;

//    [self.bottomView addSubview:shareBtn];
//    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(@(-15));
//        make.centerY.equalTo(@0);
//        make.width.height.equalTo(@20);
//    }];
    //收藏
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

//- (void)initCommentTableView1 {
//
//    self.tableView1 = [[InfoCommentDetailTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//
//    self.tableView.refreshDelegate = self;
//
//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.edges.mas_equalTo(0);
//        make.bottom.equalTo(@(-kBottomHeight-kBottomInsetHeight));
//    }];
//
//    self.footerView = [TLPlaceholderView placeholderViewWithImage:@"沙发" text:@"来, 坐下谈谈"];
//
//    self.footerView.backgroundColor = kHexColor(@"FAFCFF");
//}
#pragma mark - Init
- (InputTextView *)inputTV {
    
    if (!_inputTV) {
        
        _inputTV = [[InputTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _inputTV.delegate = self;
        
    }
    return _inputTV;
}

- (void)clickComment
{
    //回复编号  待确定
    self.replyCode = self.objectCode;
    
    self.tableView.scrollEnabled = NO;
    
    self.inputTV.commentTV.placholder = @"说出你的看法";
    
    [self.inputTV show];
    NSLog(@"点击了评论");
    
}
#pragma mark - Init
/**
 评论列表
 */
- (void)initCommentTableView {
    
    self.tableView = [[ActivityNewsCommentView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无评论"];
    
    self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
        make.bottom.equalTo(@(-kBottomInsetHeight));
    }];
    
}

#pragma mark - 通知
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCommentListt) name:@"RefreshCommentList" object:nil];
}

#pragma mark - Data
- (void)requestInfoDetail {
    
    [TLProgressHUD show];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628511";
    // type content objectCode
//    http.parameters[@"code"] = self.code;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.detailModel = [InfoDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        //获取最新评论列表
        [self requestCommentList];
        
    } failure:^(NSError *error) {
        
        [TLProgressHUD dismiss];
    }];
    
}

- (void)requestCommentList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628285";
    // type content objectCode
    helper.parameters[@"start"] = @"0";
    helper.parameters[@"limit"] = @"10";
    helper.parameters[@"objectCode"] = self.objectCode;
    helper.parameters[@"userId"] = [TLUser user].userId;

//    if ([TLUser user].userId) {
    
//        helper.parameters[@"userId"] = [TLUser user].userId;
//    }
    helper.tableView = self.tableView;
    self.helper = helper;
    
    [helper modelClass:[InfoCommentModel class]];
    
    [self.helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.comments = objs;
        weakSelf.tableView.detailModel = weakSelf.detailModel;
        weakSelf.tableView.newestComments = objs;
//        weakSelf.tableView.detailModel = weakSelf.detailModel;
//        weakSelf.tableView1.comments = objs;
        //刷新
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData_tl];
        });
        
        [TLProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        
    }];
    
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

- (void)refreshCommentListt {
    
    BaseWeakSelf;
    
    [self.helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.comments = objs;
        
//        weakSelf.tableView.detailModel = weakSelf.detailModel;
        weakSelf.tableView.newestComments = objs;
        
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)zanCommentWithComment:(InfoCommentModel *)commentModel {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628201";
    http.showView = self.view;
    http.parameters[@"type"] = @"2";
    http.parameters[@"objectCode"] = self.objectCode;
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
        //刷新资讯详情的评论列表
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCommentList" object:nil];
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - InputTextViewDelegate
- (void)clickedSureBtnWithText:(NSString *)text {
    
    NSString *code = @"628511";
    
//    NSString *type = self.isComment ? @"1": @"2";
    NSString *type = @"1";

    NSString *objectCode = self.isComment ? self.objectCode: self.replyCode;
    
    //type(1 活动2 活动评论评论)
    TLNetworking *http = [TLNetworking new];
    
    http.code = code;
    http.parameters[@"type"] = type;
    http.parameters[@"objectCode"] = objectCode;
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
        //刷新数据
        [self requestCommentList];
        //刷新圈子的评论列表
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCommentList" object:nil];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)clickedCancelBtn {
    
    self.tableView.scrollEnabled = YES;
}

//- (void)zanCommentWithComment:(InfoCommentModel *)commentModel {
//
//    TLNetworking *http = [TLNetworking new];
//
//    http.code = @"628653";
//    http.showView = self.view;
//    http.parameters[@"type"] = @"1";
//    http.parameters[@"objectCode"] = commentModel.code;
//    http.parameters[@"userId"] = [TLUser user].userId;
//
//    [http postWithSuccess:^(id responseObject) {
//
//        NSString *promptStr = [commentModel.isPoint isEqualToString:@"1"] ? @"取消点赞成功": @"点赞成功";
//        [TLAlert alertWithSucces:promptStr];
//
//        if ([commentModel.isPoint isEqualToString:@"1"]) {
//
//            commentModel.isPoint = @"0";
//            commentModel.pointCount -= 1;
//
//        } else {
//
//            commentModel.isPoint = @"1";
//            commentModel.pointCount += 1;
//        }
//
//        [self.tableView reloadData];
//        //刷新圈子的评论列表
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCommentList" object:nil];
//        //刷新跟帖量
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPostNum" object:nil];
//
//    } failure:^(NSError *error) {
//
//    }];
//}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //相关文章
    if (indexPath.section == 0) {
        
        InfoCommentModel *infoModel = self.comments[indexPath.row];
        
//        InfoDetailVC *detailVC = [InfoDetailVC new];
        ActivityNewSVC *detailVC = [ActivityNewSVC new];
//        detailVC.commentModel =infoModel;
        detailVC.code = infoModel.code;
        detailVC.title = self.titleStr;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        return ;
    }
    InfoCommentModel *commentModel = indexPath.section == 1 ? self.detailModel.hotCommentList[indexPath.row]: self.comments[indexPath.row];
    
    InfoCommentDetailVC *detailVC = [InfoCommentDetailVC new];
    
    detailVC.code = commentModel.code;
    
    [self.navigationController pushViewController:detailVC animated:YES];
//    InfoCommentModel *commentModel = indexPath.section == 0 ? self.detailModel.hotCommentList[indexPath.row]: self.comments[indexPath.row];
    
    
//    detailVC.code = self.comments[indexPath.row].code;
//    detailVC.commentModel = self.comments[indexPath.row];
//
    
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - RefreshDelegate
- (void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index {
    
    BaseWeakSelf;
    [self checkLogin:^{
        //刷新点赞状态
        [weakSelf requestCommentList];
        
    } event:^{
        
        InfoCommentModel *commentModel = index == 0 ? weakSelf.commentModel: weakSelf.commentModel.commentList[index - 1];
        if (!commentModel) {
            commentModel = weakSelf.comments[index];
        }
        
        [weakSelf zanCommentWithComment:commentModel];
    }];
}
/**
 点击回复
 */
- (void)refreshTableViewEventClick:(TLTableView *)refreshTableview selectRowAtIndex:(NSInteger)index {
    
    BaseWeakSelf;
    [self checkLogin:^{
        
        [weakSelf commentWithIndex:index];
    }];
}

- (void)commentWithIndex:(NSInteger)index {
    
    InfoCommentModel *commentModel = self.commentModel.commentList[index];
    
    self.replyCode = commentModel.code;
    self.isComment = NO;
    self.tableView.scrollEnabled = NO;
    
    self.inputTV.commentTV.placholder = [NSString stringWithFormat:@"对%@进行回复", commentModel.nickname];
    [self.inputTV show];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
