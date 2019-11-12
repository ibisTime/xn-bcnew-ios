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
    self.bottomtitles = [NSMutableArray array];
    self.bottomView.bottomtitles = self.bottomtitles;
    [self requestCurrencyTitleList];

    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //隐藏第三方键盘
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"choseOptionList" object:self.resultTitleList];

//    if (self.currencyBlock) {
//        self.currencyBlock();
//    }
    //显示第三方键盘
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Init
- (void)addSearchlItem {
    
    [UIBarButtonItem addRightItemWithTitle:@"保存" titleColor:kWhiteColor frame:CGRectMake(0, 0, 35, 44) vc:self action:@selector(saveCurreney)];
}


-(void)saveCurreney{
     CurrencyTitleModel * title;
//    self.resultTitleList = [NSMutableArray array];
    
    NSMutableArray *nameArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
//        title = self.titles[i];
        if (![self.titles[i].symbol isEqualToString:@"全部"]) {
            [nameArray addObject:self.titles[i].symbol];
        }
//        for (CurrencyTitleModel *titleModel in self.currencyTitleList) {
//            if (title.symbol == titleModel.symbol) {
//
//            }
//        }
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"628400";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"type"] = @"C";
    http.parameters[@"enameList"] = nameArray;
    //解析
    [http postWithSuccess:^(id responseObject) {
        
        
        TabbarViewController *tabbarCtrl = [[TabbarViewController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabbarCtrl;
        tabbarCtrl.selectedIndex = 1;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
    
   
    
//    if (self.resultTitleList.count > 0) {
//
//
//        [self saveObject:self.resultTitleList withKey:@"choseOptionList"];
//        TabbarViewController *tabbarCtrl = [[TabbarViewController alloc] init];
//        [UIApplication sharedApplication].keyWindow.rootViewController = tabbarCtrl;
//        tabbarCtrl.selectedIndex = 1;
//    }else{
//
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"choseOptionList"];
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"choseOptionList" object:self.resultTitleList];
////        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"choseOptionList"];
//        TabbarViewController *tabbarCtrl = [[TabbarViewController alloc] init];
//        [UIApplication sharedApplication].keyWindow.rootViewController = tabbarCtrl;
//        tabbarCtrl.selectedIndex = 1;
////        [self saveObject:self.resultTitleList withKey:@"choseOptionList"];
//    }
//    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)saveObject:(id)obj withKey:(NSString *)key

{
    
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    
    
    
    //如果是自定义对象放在数组中，先要转成NSData再保存
    
    if([obj isKindOfClass:[NSMutableArray class]]){
        
        //如果数组为空，return
        
        if([(NSMutableArray *)obj count] <= 0){
            
            return ;
            
        }
        
        
        
        //如果数组装载 Model对象
        
        if ([[(NSMutableArray *)obj objectAtIndex:0] isKindOfClass:[CurrencyTitleModel class]]){
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
            
            [udf setObject:data forKey:key];
            
        }else{ //单纯的数组
            
            [udf setObject:obj forKey:key];
            
        }
        
        
        
        [udf synchronize];
        
        return ;
        
    }
    
    
    
    if([obj isKindOfClass:[BaseModel class]]){ //如果是自定义对象，先要转成NSData再保存
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
        
        [udf setObject:data forKey:key];
        
    }else{
        
        [udf setObject:obj forKey:key];
        
    }
    
    
    
    [udf synchronize];
    
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
//        if (!self.bottomtitles) {
//            self.bottomtitles = [NSMutableArray array];
//        }
        NSMutableArray *arr = self.bottomtitles;
        CurrencyTitleModel *title = self.titles[indexPath.row];
        for (int i = 0; i < self.bottomtitles.count; i++) {
            if ([self.bottomNames containsObject:title.symbol]) {
                for (CurrencyTitleModel *titleModel in arr) {
                    if (titleModel.symbol == title.symbol) {
                        titleModel.IsSelect = NO;

                    }
                }
                
            }
        }
        self.bottomtitles = arr;
        self.bottomView.bottomtitles = self.bottomtitles;
        [self.titles removeObjectAtIndex:indexPath.row];
        self.nineView.titles = self.titles;
       
        [self.nineView reloadData];
        [self.bottomView reloadData];
        self.headView.currentCount = self.titles.count;
        self.bottomTitle.currentCount = 8-self.titles.count +1;


    }else{

        NSMutableArray *arr = self.titles;
        CurrencyTitleModel *tit = self.bottomtitles[indexPath.row];
            if ([arr containsObject:tit.symbol]) {
                return;
                
            }else{
                
                CurrencyTitleModel *title =self.bottomtitles[indexPath.row];
                if (self.titles.count == 9) {
                    [TLAlert alertWithMsg:@"最多只能选8个"];
                    return;
                }
                if (title.IsSelect == YES) {
                    return;
                }
                title.IsSelect = YES;
                [self.titles addObject:self.bottomtitles[indexPath.row]];

            }
        

        self.nineView.titles = self.titles;

        self.bottomView.bottomtitles = self.bottomtitles;
        [self.nineView reloadData];
        [self.bottomView reloadData];
        self.headView.currentCount = self.titles.count;
        self.bottomTitle.currentCount = 8 - self.titles.count + 1;


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
        
        weakSelf.tempTitles = objs;
        weakSelf.bottomtitles = objs;
        weakSelf.bottomView.bottomtitles = objs;
        [weakSelf.bottomView reloadData];
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
        //遍历标题
        
        weakSelf.tempTitles = [NSMutableArray array];
        [weakSelf.currencyTitleList enumerateObjectsUsingBlock:^(CurrencyTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.symbol) {
                
                [weakSelf.tempTitles addObject:obj];
            }
        }];
        
        weakSelf.topNames = [NSMutableArray array];
        
        [weakSelf.titles enumerateObjectsUsingBlock:^(CurrencyTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.symbol) {
                
                [weakSelf.topNames addObject:obj.symbol];
            }
        }];
        [weakSelf.topNames removeObjectAtIndex:0];
        weakSelf.bottomNames = [NSMutableArray array];
        
        [weakSelf.tempTitles enumerateObjectsUsingBlock:^(CurrencyTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.symbol) {
                
                [weakSelf.bottomNames addObject:obj.symbol];
            }
        }];
        for (int i = 0; i < weakSelf.topNames.count; i++) {
            if ([weakSelf.bottomNames containsObject:weakSelf.topNames[i]]) {
             NSInteger intger  =  [weakSelf.bottomNames indexOfObject:weakSelf.topNames[i]];
                CurrencyTitleModel *title =weakSelf.tempTitles[intger];
                title.IsSelect = YES;
                
            }
        }
        
        self.bottomtitles = weakSelf.tempTitles;
        self.bottomView.bottomtitles = weakSelf.tempTitles;
//        [self.nineView reloadData];
        
        [self.bottomView reloadData];

        //数组去重
        
    
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
