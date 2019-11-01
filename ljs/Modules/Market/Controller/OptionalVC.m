//
//  OptionalVC.m
//  ljs
//
//  Created by 郑勤宝 on 2019/10/31.
//  Copyright © 2019 caizhuoyue. All rights reserved.
//

#import "OptionalVC.h"
#import "UIButton+SGImagePosition.h"
#import "PlatformTableView.h"
#import "TLUserLoginVC.h"
#import "NavigationController.h"
#import "PlatformModel.h"
#import "TLProgressHUD.h"
#import "CurrencyKLineVC.h"
#import "BaseView.h"
#import "QuotesOptionalVC.h"
#import "OptionalTableView.h"
#import "OptionalListModel.h"
@interface OptionalVC ()
{
    UIButton *selectBtn;
}
//@property (nonatomic, strong) PlatformTableView *tableView;

@property (nonatomic , strong)NSString *direction;
@property (nonatomic, strong) OptionalTableView *tableView;
//
@property (nonatomic, strong) NSMutableArray <OptionalListModel *>*platforms;
@property (nonatomic , strong)BaseView *footerView;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation OptionalVC

-(void)viewWillAppear:(BOOL)animated
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *titleAry = @[@"涨幅榜",@"跌幅版",@"预警中"];
    for (int i = 0; i < 3; i ++) {
        UIButton *chooseBtn = [UIButton buttonWithTitle:titleAry[i] titleColor:kHexColor(@"#818181") backgroundColor:kWhiteColor titleFont:14];
        chooseBtn.frame = CGRectMake( i % 3 * (kScreenWidth/3), 0, kScreenWidth/3, 35);
        [chooseBtn SG_imagePositionStyle:(SGImagePositionStyleRight) spacing:4.5 imagePositionBlock:^(UIButton *button) {
            [button setImage:kImage(@"TriangleNomall") forState:(UIControlStateNormal)];
            [button setImage:kImage(@"TriangleSelect") forState:(UIControlStateSelected)];
        }];
        [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        chooseBtn.tag = i;
        [self.view addSubview:chooseBtn];
    }
    [self initTableView];
    [self initFooterView];
    [self loadData];
}

- (void)initTableView {
    
    self.tableView = [[OptionalTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    BaseWeakSelf;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(35, 0, 0, 0));
    }];
    self.tableView.pagingEnabled = false;
//    self.tableView.type = PlatformTypePlatform;
//    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无平台"];
    self.tableView.defaultNoDataText = @"暂无币种";
    self.tableView.defaultNoDataImage = kImage(@"暂无动态");
    self.tableView.selectBlock = ^(NSString *idear) {
        [weakSelf pushCurrencyKLineVCWith:idear];
    };
    [self.view addSubview:self.tableView];
}

- (void)initFooterView {
    
    self.footerView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight)];
    self.footerView.backgroundColor = kWhiteColor;
    
    //添加按钮
    UIButton *addBtn = [UIButton buttonWithImageName:@"添加自选"];
    [addBtn addTarget:self action:@selector(addCurrency) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(@0);
        make.left.mas_equalTo(kScreenWidth/2 - 36);
        make.top.mas_equalTo((kScreenHeight - kNavigationBarHeight - kTabBarHeight)/2 - 36 - 50);
        make.width.height.equalTo(@72);
    }];
    
    UILabel *addLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#FFA300") font:15];
    [self.footerView addSubview:addLab];
    addLab.text = @"暂无自选,点击添加";
    [addLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(addBtn);
        make.top.equalTo(addBtn.mas_bottom).offset(10);
    }];
    self.tableView.tableFooterView = self.footerView;
}

- (void)addCurrency {
    
    BaseWeakSelf;
    [self checkLogin:^{
//        [weakSelf requestOptionalList];
        //        [weakSelf startTimer];
        
        QuotesOptionalVC *optionalVC = [QuotesOptionalVC new];
        
        optionalVC.addSuccess = ^{
            
            [weakSelf.tableView beginRefreshing];
        };
        
        [weakSelf.navigationController pushViewController:optionalVC animated:YES];
    }];
}

- (void)pushCurrencyKLineVCWith:(NSString *)idear
{
    CurrencyKLineVC *kineVC = [[CurrencyKLineVC alloc]init];
    kineVC.symbolID = idear;
    [self.navigationController pushViewController:kineVC animated:YES];
}

-(void)loadData
{
    BaseWeakSelf;
    if ([TLUser user].isLogin == NO) {
        [TLProgressHUD dismiss];
        weakSelf.platforms = [PlatformModel mj_objectArrayWithKeyValuesArray:@[]];
        weakSelf.tableView.optionals = weakSelf.platforms;
        [weakSelf.tableView reloadData];
        self.footerView.hidden = NO;
    }
    else
    {
        TLNetworking *http = [TLNetworking new];
        http.code = @"628351";
        http.parameters[@"start"] = @"1";
        http.parameters[@"limit"] = @"1000";
        http.parameters[@"direction"] = self.direction;
        if ([TLUser user].userId) {
            http.parameters[@"userId"] = [TLUser user].userId;
        }
        [http postWithSuccess:^(id responseObject) {
            weakSelf.platforms = [OptionalListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            weakSelf.tableView.optionals = weakSelf.platforms;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView endRefreshHeader];
            if (weakSelf.platforms.count > 0) {
                self.footerView.hidden = YES;
            }else
            {
                self.footerView.hidden = NO;
            }
            [TLProgressHUD dismiss];
        } failure:^(NSError *error) {
            [weakSelf.tableView endRefreshHeader];
        }];
    }
}


-(void)chooseBtnClick:(UIButton *)sender
{
    if(![TLUser user].isLogin) {
        TLUserLoginVC *loginVC = [TLUserLoginVC new];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    [TLProgressHUD show];
    sender.selected = !sender.selected;
    if (selectBtn.selected == YES && selectBtn != sender) {
        selectBtn.selected = !selectBtn.selected;
    }
    selectBtn = sender;
    if (selectBtn.selected == YES) {
        switch (selectBtn.tag) {
            case 0:
            {
                self.direction = @"1";
            }
                break;
            case 1:
            {
                self.direction = @"0";
            }
                break;
            case 2:
            {
                self.direction = @"2";
            }
                break;
                
            default:
                break;
        }
    }else
    {
        self.direction = @"";
    }
    [self loadData];
    
    
    //    NSDictionary *dic = @{@"direction":@(sender.tag);
//    NSNotification *notification =[NSNotification notificationWithName:@"SwitchDirection" object:nil userInfo:dic];
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
}



@end
