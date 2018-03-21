//
//  QuotesOptionalVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "QuotesOptionalVC.h"

//Macro
//Framework
//Category
#import "UIBarButtonItem+convience.h"
//Extension
//M
//V
#import "SelectScrollView.h"
//C
#import "QuotesOptionalChildVC.h"

@interface QuotesOptionalVC ()
//
@property (nonatomic, strong) SelectScrollView *selectSV;
//titles
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
    //
    [self initSelectScrollView];
    //
    [self addSubViewController];
}

#pragma mark - Init
- (void)addItem {
    
    [UIBarButtonItem addRightItemWithTitle:@"完成" titleColor:kWhiteColor frame:CGRectMake(0, 0, 44, 40) vc:self action:@selector(confirm)];
}

- (void)initSelectScrollView {
    
    self.titles = @[@"BTC", @"BCH", @"ETH", @"OKEx", @"BigONE", @"币安", @"ZB", @"Gate", @"Bitfinex"];

    SelectScrollView *selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) itemTitles:self.titles];
    
    [self.view addSubview:selectSV];
    
    self.selectSV = selectSV;
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        //可选
        QuotesOptionalChildVC *childVC = [[QuotesOptionalChildVC alloc] init];
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight);
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
