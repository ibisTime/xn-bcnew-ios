//
//  MarketVC.m
//  ljs
//
//  Created by 郑勤宝 on 2019/10/30.
//  Copyright © 2019 caizhuoyue. All rights reserved.
//

#import "MarketVC.h"
#import "TopLabelUtil.h"
#import "CurrencyVC.h"
#import "OptionalVC.h"
#import "QuotesOptionalVC.h"
#import "NewSearchViewController.h"
#import "UIBarButtonItem+convience.h"
#import "NavigationController.h"
@interface MarketVC ()<SegmentDelegate,UIScrollViewDelegate>
@property (nonatomic , strong)TopLabelUtil *labelUnil;

@property (nonatomic, strong)UIScrollView *scroll;
//@property (nonatomic, strong)UIButton *selectBtn;

@property (nonatomic, assign)NSInteger currentPages;

//@property (nonatomic, strong)UILabel *WeiGreLabel;
@property (nonatomic,strong) CurrencyVC * vc1;
@property (nonatomic,strong) OptionalVC * vc2;

#define kPageCount 2
#define kButton_H 50
#define kMrg 10
#define kTag 1000

@end

@implementation MarketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationView];
    
    //设置可以左右滑动的ScrollView
    [self setupScrollView];
    //设置控制的每一个子控制器
    [self setupChildViewControll];
    //设置分页按钮
//    [self setupPageButton];
    //选择状态
//    [self setupSelectBtn];
    [_scroll setContentOffset:CGPointMake(kScreenWidth * _currentPages, 0) animated:YES];
    [self addItem];
    
    
    
}



#pragma mark - Events
- (void)addItem {
    //添加选择
//    [UIBarButtonItem addLeftItemWithImageName:@"添加" frame:CGRectMake(0, 0, 40, 40) vc:self action:@selector(addCurrency)];
    //搜索
    [UIBarButtonItem addRightItemWithImageName:@"搜索" frame:CGRectMake(0, 0, 40, 40) vc:self action:@selector(search)];
//    NSLog(@"%@",NSStringFromCGRect(self.tableView.superview.frame));
    
}

- (void)addCurrency {
    
    
    BaseWeakSelf;
    [self checkLogin:^{
        QuotesOptionalVC *optionalVC = [QuotesOptionalVC new];
        optionalVC.addSuccess = ^{
//
//            [weakSelf.tableView beginRefreshing];
        };
        [weakSelf.navigationController pushViewController:optionalVC animated:YES];
    }];
}

/**
 搜索
 */
- (void)search {
    BaseWeakSelf;
    NewSearchViewController *searchVC = [NewSearchViewController new];
    //    searchVC.currencyBlock = ^{
    //        [weakSelf.tableView beginRefreshing];
    //    };
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:nav animated:YES completion:nil];
}


-(void)initNavigationView
{
    NSArray *titleArr = @[
                          @"币种",
                          @"自选"];
    
    CGFloat h = 34-4;
    
    self.labelUnil = [[TopLabelUtil alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.labelUnil.delegate = self;
    self.labelUnil.backgroundColor = kWhiteColor;
    self.labelUnil.titleNormalColor = kTextColor;
    self.labelUnil.titleSelectColor = kAppCustomMainColor;
    self.labelUnil.titleFont = Font(16.0);
    self.labelUnil.lineType = LineTypeButtonLength;
    self.labelUnil.titleArray = titleArr;
    self.labelUnil.layer.cornerRadius = h/2.0;
    self.labelUnil.layer.borderWidth = 1;
    self.labelUnil.backgroundColor = kWhiteColor;
    self.labelUnil.titleNormalColor = kTextColor;
    self.labelUnil.titleSelectColor = kAppCustomMainColor;
    self.labelUnil.layer.borderColor = kLineColor.CGColor;
    self.navigationItem.titleView = self.labelUnil;
}

-(void)segment:(TopLabelUtil *)segment didSelectIndex:(NSInteger)index;
{
    self.currentPages = index - 1;
    [self gotoCurrentPage];
    
    if (self.currentPages == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.vc1.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            self.vc2.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.vc1.view.frame = CGRectMake(-kScreenHeight, 0, kScreenWidth, kScreenHeight);
            self.vc2.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        }];
    }
    
}

#pragma mark - 设置可以左右滑动的ScrollView
- (void)setupScrollView{
    
    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0 , kScreenWidth, kScreenHeight)];
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;
    _scroll.bounces = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.directionalLockEnabled = YES;
    _scroll.contentSize = CGSizeMake(kScreenWidth * kPageCount, 0);
    [self.view addSubview:_scroll];
}

#pragma mark - 设置控制的每一个子控制器
- (void)setupChildViewControll{
    self.vc1 = [[CurrencyVC alloc]init];
    self.vc2 = [[OptionalVC alloc]init];
    
    //指定该控制器为其子控制器
    [self addChildViewController:_vc1];
    [self addChildViewController:_vc2];

    
    
    //将视图加入ScrollView上
    [self.view addSubview:_vc1.view];
    [self.view addSubview:_vc2.view];
   
    
    //设置两个控制器的尺寸
    _vc1.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _vc2.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
//    _vc3.view.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
}

#pragma mark -- 按钮点击方法
//- (void)pageClick:(UIButton *)btn
//{
//    self.currentPages = btn.tag - kTag;
//    [self gotoCurrentPage];
////    [self setupSelectBtn];
//}


#pragma mark -   进入当前的选定页面
- (void)gotoCurrentPage{
    CGRect frame;
    frame.origin.x = self.scroll.frame.size.width * self.currentPages;
    frame.origin.y = 0;
    frame.size = _scroll.frame.size;
    
    
    
//    [_scroll setContentOffset:CGPointMake(kScreenWidth * _currentPages, 0) animated:YES];
}

#pragma mark - ScrollView delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat pageWidth = _scroll.frame.size.width;
//    self.currentPages = floor((_scroll.contentOffset.x - pageWidth/2)/pageWidth) + 1;
//    self.labelUnil.defaultSelectIndex = self.currentPages;
//    //设置选中button的样式
////    [self setupSelectBtn];
//}


- (void)segmenChildLableClick: (NSInteger)segment : (NSInteger)labIndex
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
