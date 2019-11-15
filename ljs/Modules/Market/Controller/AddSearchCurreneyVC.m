//
//  AddSearchCurreneyVC.m
//  ljs
//
//  Created by shaojianfei on 2018/5/29.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AddSearchCurreneyVC.h"
//Category
#import "UIBarButtonItem+convience.h"
//Extension
#import <IQKeyboardManager.h>
//M
#import "CurrencyModel.h"
//V
#import "SelectScrollView.h"
#import "TLTextField.h"
#import "SearchHistoryTableView.h"
#import "SearchCurrencyTableView.h"
#import "TLPlaceholderView.h"
//C
#import "SearchCurrcneyChildVC.h"
#import "SearchHistoryChildVC.h"
#import "QHCollectionViewNine.h"
#import "AddSearchHeadView.h"
#import "AddSearchBottomView.h"
#import "AddNumberModel.h"
#import "TabbarViewController.h"
@interface AddSearchCurreneyVC ()<UITextFieldDelegate, RefreshDelegate,addCollectionViewDelegate>

//titles
//statusList
@property (nonatomic, strong) NSArray *statusList;
//搜索
@property (nonatomic, strong) TLTextField *searchTF;
//行情列表
@property (nonatomic, strong) SearchCurrencyTableView *currencyTableView;
//
@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*currencys;
//搜索内容
@property (nonatomic, copy) NSString *searchStr;
//
@property (nonatomic, strong) TLPageDataHelper *helper;
//热门
@property (nonatomic, strong) SearchCurrcneyChildVC *currencyVC;
//搜索历史
@property (nonatomic, strong) SearchHistoryChildVC *historyVC;

@property (nonatomic, strong) UIScrollView * contentScrollView;

@property (nonatomic, strong) QHCollectionViewNine *nineView;
@property (nonatomic, strong) QHCollectionViewNine *bottomView;

@property (nonatomic, strong)  AddSearchHeadView *headView;
@property (nonatomic, strong)  AddSearchBottomView *bottomTitle;

@property (nonatomic, strong) NSMutableArray *topNames;
@property (nonatomic, strong) NSMutableArray *bottomNames;

@end

@implementation AddSearchCurreneyVC



- (void)viewDidLoad {
    [super viewDidLoad];

    [self addSearchlItem];
    [self initSearchBar];
    [self initSubViews];
    [self initCollectionViewBottom];
    
    
    self.nineView.titles = self.titles;
    self.headView.currentCount = self.titles.count ;
    self.bottomTitle.currentCount = 8-self.titles.count + 1;
//    self.bottomtitles = [NSMutableArray array];
//    self.bottomView.bottomtitles = self.bottomtitles;
    
    [self topCurrencyTitleList];
    

    // Do any additional setup after loading the view.
}

-(void)topCurrencyTitleList
{
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"628405";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"type"] = @"C";
    //解析
    [http postWithSuccess:^(id responseObject) {
        
        self.titles = [CurrencyTitleModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        self.nineView.titles = self.titles;
        self.headView.currentCount = self.titles.count;
        self.bottomTitle.currentCount = self.titles.count;
        [self.nineView reloadData];
        [self requestCurrencyTitleList];
        
    } failure:^(NSError *error) {
        
    }];
}



- (void)requestCurrencyTitleList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628307";
    helper.isList = YES;
    
    [helper modelClass:[CurrencyTitleModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        weakSelf.currencyTitleList = objs;

        for (int i = 0; i < weakSelf.titles.count; i++) {
            for (int j = 0; j < weakSelf.currencyTitleList.count; j ++ ) {
                if ([weakSelf.titles[i].navName isEqualToString:weakSelf.currencyTitleList[j].symbol]) {
//                    NSInteger intger  =  [weakSelf.bottomNames indexOfObject:weakSelf.topNames[i]];
                    CurrencyTitleModel *title = weakSelf.currencyTitleList[j];
                    title.IsSelect = YES;
                    
                }
            }
        }
        
        
        self.bottomtitles = weakSelf.currencyTitleList;
        
        self.bottomView.bottomtitles = weakSelf.bottomtitles;
        
        
        //        [self.nineView reloadData];
        
        [self.bottomView reloadData];
        
        //数组去重
        
        
    } failure:^(NSError *error) {
    }];
}









- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //隐藏第三方键盘
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"choseOptionList" object:self.resultTitleList];

    if (self.currencyBlock) {
        self.currencyBlock();
    }
//    TabbarViewController *tabbarCtrl = [[TabbarViewController alloc] init];
//    [UIApplication sharedApplication].keyWindow.rootViewController = tabbarCtrl;
//    tabbarCtrl.selectedIndex = 1;
//    [self.navigationController popToRootViewControllerAnimated:YES];

    
    
    //显示第三方键盘
//    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
//    [[IQKeyboardManager sharedManager] setEnable:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Init
- (void)addSearchlItem {
    
    [UIBarButtonItem addRightItemWithTitle:@"搜索" titleColor:kWhiteColor frame:CGRectMake(0, 0, 35, 44) vc:self action:@selector(saveCurreney)];
}


-(void)saveCurreney{
//     CurrencyTitleModel * title;
    
    
    self.searchStr = self.searchTF.text;
    
    //保存搜索记录
    //获取搜索结果
    self.helper.parameters[@"keywords"] = self.searchStr;
    [self requestSearchResult];
    
}

- (void)initSubViews
{
    
    UIScrollView * contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight-44)];
    
    [self.view addSubview:contentScrollView];
    self.contentScrollView = contentScrollView;
    
    AddSearchHeadView *headView = [[AddSearchHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    self.headView = headView;
    
    headView.numberModel = [AddNumberModel new];
    
    
    AddSearchBottomView *bottomTitle = [[AddSearchBottomView alloc] initWithFrame:CGRectMake(0, 250, kScreenWidth, 35)];
    self.bottomTitle = bottomTitle;
    bottomTitle.numberModel = [AddNumberModel new];
    [contentScrollView addSubview:headView];
    [contentScrollView addSubview:bottomTitle];
    
    //
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(80, 50);
    layout.minimumLineSpacing = 10.0; // 竖
    layout.minimumInteritemSpacing = 10.0; // 横
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    UIImage *image1 = [UIImage imageNamed:@"金"];
    UIImage *image2 = [UIImage imageNamed:@"银"];
    UIImage *image3 = [UIImage imageNamed:@"铜"];
    NSArray *array = @[image2, image2, image3, image2, image3, image1, image3, image1, image1];
    
    QHCollectionViewNine *nineView = [[QHCollectionViewNine alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 200) collectionViewLayout:layout withImage:array];
    self.nineView = nineView;
    self.nineView.type = SearchTypeTop;
    nineView.refreshDelegate = self;
    [self.view addSubview:nineView];
    
}
- (void)initCollectionViewBottom
{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(80, 50);
    layout.minimumLineSpacing = 10.0; // 竖
    layout.minimumInteritemSpacing = 10.0; // 横
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    UIImage *image1 = [UIImage imageNamed:@"金"];
    UIImage *image2 = [UIImage imageNamed:@"银"];
    UIImage *image3 = [UIImage imageNamed:@"铜"];
    NSArray *array = @[image2, image2, image3, image2, image3, image1, image3, image1, image1];
    
    QHCollectionViewNine *bottomView = [[QHCollectionViewNine alloc] initWithFrame:CGRectMake(0, 300, kScreenWidth, kScreenHeight - 300 - kNavigationBarHeight) collectionViewLayout:layout withImage:array];
    self.bottomView = bottomView;
    bottomView.refreshDelegate = self;
    self.bottomView.type = SearchTypeBottom;
    [self.view addSubview:bottomView];
    
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
                                           placeholder:@"栏目搜索"];
    self.searchTF.delegate = self;
    self.searchTF.returnKeyType = UIReturnKeySearch;
    
    [self.searchTF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [searchBgView addSubview:self.searchTF];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 13, 0, 0));
        make.width.mas_greaterThanOrEqualTo(kScreenWidth - 20 - 40 -50-  15 - 13);
    }];
    
}
- (void)refreshCollectionView:(QHCollectionViewNine *)refreshCollectionview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.searchTF resignFirstResponder];
    if (refreshCollectionview.type == SearchTypeTop) {
        //上面的要删除
        if (indexPath.row == 0) {
            return;
        }
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"628401";
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"type"] = @"C";
        http.parameters[@"id"] = self.titles[indexPath.row - 1].ID;
        //解析
        [http postWithSuccess:^(id responseObject) {
            
            [self topCurrencyTitleList];
            [TLAlert alertWithSucces:@"移除成功"];
            
        } failure:^(NSError *error) {
            
        }];

        

    }else{

        
        for (int i = 0; i < self.titles.count; i ++) {
            if ([self.bottomtitles[indexPath.row].symbol isEqualToString:self.titles[i].navName]) {
                [TLAlert alertWithSucces:@"已存在该币种"];
                return;
            }
        }
        
        
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"628400";
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"type"] = @"C";
        http.parameters[@"enameList"] = @[self.bottomtitles[indexPath.row].ename];
        //解析
        [http postWithSuccess:^(id responseObject) {
            
            [self topCurrencyTitleList];
            [TLAlert alertWithSucces:@"操作成功"];
            
            
            
            
//            TabbarViewController *tabbarCtrl = [[TabbarViewController alloc] init];
//            [UIApplication sharedApplication].keyWindow.rootViewController = tabbarCtrl;
//            tabbarCtrl.selectedIndex = 1;
//            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
        }];

        

    }
    

    NSLog(@"%s",__func__);
    
}

-(void)refreshCollectionViewButtonClick:(QHCollectionViewNine *)refreshCollectionView WithButton:(UIButton *)sender SelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSLog(@"%s",__func__);

    
}
- (void)textDidChange:(UITextField *)sender {
    
//    self.currencyTableView.hidden = sender.text.length == 0 ? YES: NO;
//    //搜索框没有搜索时，显示
//    if (sender.text.length == 0) {
//
//        self.selectSV.hidden = NO;
//    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    self.searchStr = textField.text;
    
    //保存搜索记录
    //获取搜索结果
    self.helper.parameters[@"keywords"] = self.searchStr;
    [self requestSearchResult];
    
    return YES;
}


- (void)requestSearchResult
{
    
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628350";
    helper.isList = NO;
    
    if ([TLUser user].userId) {
        
        helper.parameters[@"userId"] = [TLUser user].userId;
    }
    
    helper.parameters[@"keywords"] = self.searchStr;
    [helper modelClass:[CurrencyTitleModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.currencyTitleList = objs;
        
        for (int i = 0; i < weakSelf.titles.count; i++) {
            for (int j = 0; j < weakSelf.currencyTitleList.count; j ++ ) {
                if ([weakSelf.titles[i].navName isEqualToString:weakSelf.currencyTitleList[j].symbol]) {
                    //                    NSInteger intger  =  [weakSelf.bottomNames indexOfObject:weakSelf.topNames[i]];
                    CurrencyTitleModel *title = weakSelf.currencyTitleList[j];
                    title.IsSelect = YES;
                    
                }
            }
        }
        
        
        self.bottomtitles = weakSelf.currencyTitleList;
        
        self.bottomView.bottomtitles = weakSelf.bottomtitles;
        
        
        //        [self.nineView reloadData];
        
        [self.bottomView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
   
    
    
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.searchTF resignFirstResponder];
    
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
