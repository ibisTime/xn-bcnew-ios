

//
//  CurrencyVC.m
//  ljs
//
//  Created by 郑勤宝 on 2019/10/31.
//  Copyright © 2019 caizhuoyue. All rights reserved.
//

#import "CurrencyVC.h"
#import "CurrencyTitleModel.h"
#import "SelectScrollView.h"
#import "CurrencyHomeVC.h"
#import "UIButton+SGImagePosition.h"
#import "TLUserLoginVC.h"
#import "NavigationController.h"
#import "TLProgressHUD.h"
#import "AddSearchCurreneyVC.h"
@interface CurrencyVC ()
{
    UIButton *selectBtn;
    NSInteger direction;
    NSString *keywords;
    
    NSString *orderDir;
    NSString *orderColumn;
}
@property (nonatomic , strong)NSMutableArray <CurrencyTitleModel *>*currencyTitleList;
@property (nonatomic , strong)NSMutableArray *titles;

@end

@implementation CurrencyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if ([TLUser user].isLogin == YES) {
//        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
////        self.currencyTitleList  =[NSMutableArray array];
//        NSData *data = [user objectForKey:@"choseOptionList"];
//        self.currencyTitleList = [CurrencyTitleModel mj_objectArrayWithKeyValuesArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];

        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"628405";
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"type"] = @"C";
        //解析
        [http postWithSuccess:^(id responseObject) {
            
            
            self.currencyTitleList = [CurrencyTitleModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            self.titles = [NSMutableArray arrayWithObject:@"全部"];
            if (self.currencyTitleList.count > 0) {
                [self.currencyTitleList enumerateObjectsUsingBlock:^(CurrencyTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    obj.symbol = obj.navName;
                    if (obj.navName && ![obj.navName isEqualToString:@""]) {
                        [self.titles addObject:obj.navName];
                    }
                }];
            }
            [self chose];
            
        } failure:^(NSError *error) {
            
        }];

    }else
    {
        BaseWeakSelf;
        

        
        TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
        
        helper.code = @"628335";
//        helper.parameters[@"location"] = @"1";
        helper.isList = YES;
        
        [helper modelClass:[CurrencyTitleModel class]];
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {

            weakSelf.currencyTitleList = objs;
            self.titles = [NSMutableArray arrayWithObject:@"全部"];
            if (self.currencyTitleList.count > 0) {
                [self.currencyTitleList enumerateObjectsUsingBlock:^(CurrencyTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if (obj.ename && ![obj.ename isEqualToString:@""]) {
                        [self.titles addObject:obj.ename];
                    }
                }];
            }
            [self chose];

        } failure:^(NSError *error) {
        }];
        

    }
    
    
    
    orderDir = @"";
    orderColumn = @"";
//    self.view.backgroundColor = kBlackColor;
}



- (void)chose
{
    
    
    NSLog(@"currencyTitleList%@",self.currencyTitleList);
    
    
    
    SelectScrollView *selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 50, kSuperViewHeight - kTabBarHeight) itemTitles:self.titles];
    
    selectSV.selectBlock = ^(NSInteger index) {

    };
    [self.view addSubview:selectSV];
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
//        NSArray *statusList = @[kAllNewsFlash, kHotNewsFlash];
        CurrencyHomeVC *childVC = [[CurrencyHomeVC alloc] init];
        childVC.view.frame = CGRectMake(kScreenWidth*i, 0, kScreenWidth, kSuperViewHeight - 45 - kTabBarHeight);
        if (i == 0) {
            childVC.symbol = @"";
        }else
        {
            childVC.symbol = self.titles[i];
        }
            
        [self addChildViewController:childVC];
        [selectSV.scrollView addSubview:childVC.view];
    }
    
    //添加按钮
    UIButton *addBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [addBtn setImage:kImage(@"添加 黑色") forState:(UIControlStateNormal)];
    addBtn.frame = CGRectMake(kScreenWidth - 50, 0, 50, 45);
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setBackgroundColor:kWhiteColor forState:(UIControlStateNormal)];
    [self.view addSubview:addBtn];
    
    NSArray *titleAry = @[@"市值榜",@"涨跌幅",@"成交量"];
    for (int i = 0; i < 3; i ++) {
        UIButton *chooseBtn = [UIButton buttonWithTitle:titleAry[i] titleColor:kHexColor(@"#818181") backgroundColor:kWhiteColor titleFont:14];
        chooseBtn.frame = CGRectMake( i % 3 * (kScreenWidth/3), 45, kScreenWidth/3, 35);
        [chooseBtn SG_imagePositionStyle:(SGImagePositionStyleRight) spacing:4.5 imagePositionBlock:^(UIButton *button) {
            [button setImage:kImage(@"行情未选中") forState:(UIControlStateNormal)];
//            [button setImage:kImage(@"TriangleSelect") forState:(UIControlStateSelected)];
        }];
        [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        chooseBtn.tag = i;
        [self.view addSubview:chooseBtn];
    }
}

- (void)addBtnClick
{
    //添加币种
    
    BaseWeakSelf;
    
    AddSearchCurreneyVC *searchVC = [AddSearchCurreneyVC new];
    //    searchVC.currencyTitleList = self.currencyTitleList;
    searchVC.titles = [NSMutableArray array];
    CurrencyTitleModel * titleModel = [CurrencyTitleModel new];
    titleModel.symbol = @"全部";
    
    
    if ([TLUser user].isLogin == YES) {
        
    }
    
    [self checkLogin:^{

        [weakSelf.navigationController pushViewController:searchVC animated:YES];
    }];
    
    
    searchVC.currencyBlock = ^{
        
        if ([TLUser user].isLogin == YES) {

            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
            http.code = @"628405";
            http.parameters[@"userId"] = [TLUser user].userId;
            http.parameters[@"type"] = @"C";
            //解析
            [http postWithSuccess:^(id responseObject) {
                
                
                self.currencyTitleList = [CurrencyTitleModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                self.titles = [NSMutableArray arrayWithObject:@"全部"];
                if (self.currencyTitleList.count > 0) {
                    [self.currencyTitleList enumerateObjectsUsingBlock:^(CurrencyTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        obj.symbol = obj.navName;
                        if (obj.navName && ![obj.navName isEqualToString:@""]) {
                            [self.titles addObject:obj.navName];
                        }
                    }];
                }
                [self chose];
                
            } failure:^(NSError *error) {
                
            }];
            
        }else
        {
            BaseWeakSelf;
            
            
            
            TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
            
            helper.code = @"628335";
            //        helper.parameters[@"location"] = @"1";
            helper.isList = YES;
            
            [helper modelClass:[CurrencyTitleModel class]];
            
            [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
                
                weakSelf.currencyTitleList = objs;
                self.titles = [NSMutableArray arrayWithObject:@"全部"];
                if (self.currencyTitleList.count > 0) {
                    [self.currencyTitleList enumerateObjectsUsingBlock:^(CurrencyTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        if (obj.ename && ![obj.ename isEqualToString:@""]) {
                            [self.titles addObject:obj.ename];
                        }
                    }];
                }
                [self chose];
                
            } failure:^(NSError *error) {
            }];
            
            
        }
        
        orderDir = @"";
        orderColumn = @"";
    };
}

-(void)chooseBtnClick:(UIButton *)sender
{
//    if (sender.tag == 2) {
//        if(![TLUser user].isLogin) {
//            TLUserLoginVC *loginVC = [TLUserLoginVC new];
////            loginVC.loginSuccess = loginSuccess;
//            NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
//            [self presentViewController:nav animated:YES completion:nil];
//            return ;
//        }
//    }
    
    [TLProgressHUD show];
    sender.selected = !sender.selected;
    if (selectBtn.selected == YES && selectBtn != sender) {
        selectBtn.selected = !selectBtn.selected;
        [selectBtn setImage:kImage(@"行情未选中") forState:(UIControlStateNormal)];
    }
    [selectBtn setImage:kImage(@"行情未选中") forState:(UIControlStateNormal)];
    selectBtn = sender;
    
    NSDictionary *dic;
    if (![orderColumn isEqualToString:[NSString stringWithFormat:@"%ld",sender.tag]]) {
        orderDir = @"";
        orderColumn = @"";
    }
    
    orderColumn = [NSString stringWithFormat:@"%ld",sender.tag];
    if ([orderDir isEqualToString:@""]) {
        
        orderDir = @"1";
        [selectBtn setImage:kImage(@"行情涨") forState:(UIControlStateNormal)];
    }else if ([orderDir isEqualToString:@"1"]) {
        orderDir = @"0";
        [selectBtn setImage:kImage(@"行情跌") forState:(UIControlStateNormal)];
    }else if ([orderDir isEqualToString:@"0"]) {
        orderDir = @"";
        [selectBtn setImage:kImage(@"行情未选中") forState:(UIControlStateNormal)];
        orderColumn = @"";
    }
    
    dic = @{@"orderColumn":orderColumn,
            @"orderDir":orderDir
            };
    NSNotification *notification =[NSNotification notificationWithName:@"SwitchDirection" object:nil userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}



-(void)addCurrency
{
    
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