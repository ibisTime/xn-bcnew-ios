//
//  SearchForumVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SearchForumVC.h"
//Category
#import "UIBarButtonItem+convience.h"
//Extension
//M
#import "ForumModel.h"
//V
#import "SelectScrollView.h"
#import "TLTextField.h"
#import "SearchHistoryTableView.h"
#import "ForumListTableView.h"
#import "TLPlaceholderView.h"
//C
#import "ForumDetailVC.h"

@interface SearchForumVC ()<UITextFieldDelegate, RefreshDelegate>

//
@property (nonatomic, strong) SelectScrollView *selectSV;
//titles
@property (nonatomic, strong) NSArray *titles;
//statusList
@property (nonatomic, strong) NSArray *statusList;
//搜索
@property (nonatomic, strong) TLTextField *searchTF;
//
@property (nonatomic, strong) SearchHistoryTableView *historyTableView;
//币吧列表
@property (nonatomic, strong) ForumListTableView *forumTableView;
//
@property (nonatomic, strong) NSMutableArray <ForumModel *>*forums;
//搜索内容
@property (nonatomic, copy) NSString *searchStr;
//
@property (nonatomic, strong) TLPageDataHelper *helper;

@end

@implementation SearchForumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //取消
    [self addCancelItem];
    //搜索
    [self initSearchBar];
    //历史搜索
    [self initHistoryTableView];
    //搜索结果
    [self initResultTableView];
    //搜索结果
    [self requestSearchList];
    //获取历史搜索记录
    [self getHistoryRecords];
}

#pragma mark - Init
- (void)addCancelItem {
    
    [UIBarButtonItem addRightItemWithTitle:@"取消" titleColor:kWhiteColor frame:CGRectMake(0, 0, 35, 44) vc:self action:@selector(back)];
}

- (void)initSearchBar {
    
    [UINavigationBar appearance].barTintColor = kAppCustomMainColor;
    CGFloat height = 35;
    //搜索
    UIView *searchBgView = [[UIView alloc] init];
    //    UIView *searchBgView = [[UIView alloc] init];
    
    searchBgView.backgroundColor = kWhiteColor;
    searchBgView.userInteractionEnabled = YES;
    searchBgView.layer.cornerRadius = height/2.0;
    searchBgView.clipsToBounds = YES;
    
    self.navigationItem.titleView = searchBgView;
    
    [searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    //搜索输入框
    self.searchTF = [[TLTextField alloc] initWithFrame:CGRectZero
                                             leftTitle:@""
                                            titleWidth:0
                                           placeholder:@"请输入吧名"];
    self.searchTF.delegate = self;
    
    [self.searchTF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [searchBgView addSubview:self.searchTF];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 13, 0, 0));
        
        make.width.mas_greaterThanOrEqualTo(kScreenWidth - 20 - 40 -  15 - 13);
    }];
    
}

- (void)initHistoryTableView {
    
    self.historyTableView = [[SearchHistoryTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.historyTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"没有查找到历史搜索" topMargin:100];
    
    self.historyTableView.refreshDelegate = self;
    
    [self.view addSubview:self.historyTableView];
    [self.historyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

- (void)initResultTableView {
    
    self.forumTableView = [[ForumListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.forumTableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"没有搜索到币吧"];
    self.forumTableView.refreshDelegate = self;
    
    [self.view addSubview:self.forumTableView];
    [self.forumTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    
    self.forumTableView.hidden = YES;
}

#pragma mark - Events

- (void)saveSearchRecord {
    
    self.historyTableView.hidden = YES;
    //保存搜索记录
    NSArray *myarray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"HistorySearch"];
    
    NSMutableArray *historyArr = [myarray mutableCopy];
    
    [historyArr addObject:self.searchStr];
    
    if (historyArr==nil) {
        
        historyArr = [[NSMutableArray alloc]init];
        
    }else if ([historyArr containsObject:self.searchStr]) {
        
        [historyArr removeObject:self.searchStr];
    }
    [historyArr insertObject:self.searchStr atIndex:0];
    
    NSUserDefaults *mydefaults = [NSUserDefaults standardUserDefaults];
    
    [mydefaults setObject:historyArr forKey:@"HistorySearch"];
    
    [mydefaults synchronize];
    //刷新数据
    [self getHistoryRecords];
    
    self.historyTableView.hidden = YES;
}

- (void)textDidChange:(UITextField *)sender {
    
    self.forumTableView.hidden = sender.text.length == 0 ? YES: NO;
    //    self.historyTableView.hidden = sender.text.length == 0 ?NO: YES;
}

- (void)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Data
- (void)getHistoryRecords {
    
    NSArray *myarray = [[NSUserDefaults standardUserDefaults]arrayForKey:@"HistorySearch"];
    
    NSUserDefaults *mydefaults = [NSUserDefaults standardUserDefaults];
    
    if (myarray == nil) {
        
        NSArray *historyArr = @[];
        
        [mydefaults setObject:historyArr forKey:@"HistorySearch"];
    }
    
    if (myarray.count == 0) {
        
        self.historyTableView.tableFooterView =         self.historyTableView.placeHolderView;
    } else {
        
        [self.historyTableView.placeHolderView removeFromSuperview];
        self.historyTableView.historyRecords = myarray;
        [self.historyTableView reloadData];
    }
}

/**
 获取搜索结果
 */
- (void)requestSearchList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628237";
    helper.parameters[@"keywords"] = self.searchStr;
    
    if ([TLUser user].userId) {
        
        helper.parameters[@"userId"] = [TLUser user].userId;
    }
    
    helper.tableView = self.forumTableView;
    
    [helper modelClass:[ForumModel class]];
    
    self.helper = helper;
    
    [self.forumTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.forums = objs;
            
            weakSelf.forumTableView.forums = objs;
            
            [weakSelf.forumTableView reloadData_tl];
            
            weakSelf.forumTableView.hidden = NO;
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.forumTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.forums = objs;
            
            weakSelf.forumTableView.forums = objs;
            
            [weakSelf.forumTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.forumTableView endRefreshingWithNoMoreData_tl];
}

/**
 关注
 */
- (void)followForum:(NSInteger)index {
    
    ForumModel *forumModel = self.forums[index];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628240";
    http.parameters[@"code"] = forumModel.code;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *promptStr = [forumModel.isKeep isEqualToString:@"1"] ? @"取消关注成功": @"关注成功";
        [TLAlert alertWithSucces:promptStr];
        
        if ([forumModel.isKeep isEqualToString:@"1"]) {
            
            forumModel.isKeep = @"0";
            forumModel.keepCount -= 1;
            
        } else {
            
            forumModel.isKeep = @"1";
            forumModel.keepCount += 1;
        }
        
        [self.forumTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    self.searchStr = textField.text;
    
    //保存搜索记录
    [self saveSearchRecord];
    //获取搜索结果
    self.helper.parameters[@"keywords"] = self.searchStr;
    [self.forumTableView beginRefreshing];
    
    return YES;
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([refreshTableview isKindOfClass:[ForumListTableView class]]) {
        
        ForumDetailVC *detailVC = [ForumDetailVC new];
        
        detailVC.type = ForumEntrancetypeForum;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    //获取搜索结果
    self.helper.parameters[@"keywords"] = self.historyTableView.historyRecords[indexPath.row];
    [self.forumTableView beginRefreshing];
}

- (void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index {
    
    BaseWeakSelf;
    [self checkLogin:^{
        
        [weakSelf followForum:index];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
