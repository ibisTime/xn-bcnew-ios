//
//  QuotesOptionalVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "QuotesOptionalVC.h"

//Category
#import "UIBarButtonItem+convience.h"
//M
#import "OptionalTitleModel.h"
//V
#import "SelectScrollView.h"
//C
#import "QuotesOptionalChildVC.h"

@interface QuotesOptionalVC ()

@property (nonatomic, strong) NSString *cvalue;
//
@property (nonatomic, strong) SelectScrollView *selectSV;
//titles
@property (nonatomic, strong) NSArray *titleList;
@property (nonatomic, strong) NSArray *titles;
//statusList
@property (nonatomic, strong) NSArray *statusList;

@end

@implementation QuotesOptionalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加自选";
    //完成
    [self addItem];
    //获取自选title
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628917";
    
    http.parameters[@"ckey"] = @"choice_coin_list";
    [http postWithSuccess:^(id responseObject) {
        
        self.cvalue = responseObject[@"data"][@"cvalue"];
        [self initSelectScrollView];
    } failure:^(NSError *error) {
        
    }];
    
    
}

#pragma mark - Init
- (void)addItem {
    
    [UIBarButtonItem addRightItemWithTitle:@"完成" titleColor:kWhiteColor frame:CGRectMake(0, 0, 44, 40) vc:self action:@selector(confirm)];
}

- (void)initSelectScrollView {
    
//    self.titles = [NSMutableArray array];
    
    self.titles = [_cvalue componentsSeparatedByString:@","];
    
    SelectScrollView *selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) itemTitles:self.titles.copy];
    
    [self.view addSubview:selectSV];
    
    self.selectSV = selectSV;
    [self addSubViewController];
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        //可选
        QuotesOptionalChildVC *childVC = [[QuotesOptionalChildVC alloc] init];
        
        childVC.titleStr = self.titles[i];
        childVC.addSuccess = self.addSuccess;
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40);
        
        [self addChildViewController:childVC];
        
        [self.selectSV.scrollView addSubview:childVC.view];
    }
}

#pragma mark - Events
/**
 完成
 */
- (void)confirm {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Data
- (void)requestTitleList {
    
//    BaseWeakSelf;
//
//    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
//
//    helper.code = @"628335";
//    helper.isList = YES;
//
//    [helper modelClass:[OptionalTitleModel class]];
//
//    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
//
//        weakSelf.titleList = objs;
//        //
//        [weakSelf initSelectScrollView];
//        //
//        [weakSelf addSubViewController];
//
//    } failure:^(NSError *error) {
//
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
