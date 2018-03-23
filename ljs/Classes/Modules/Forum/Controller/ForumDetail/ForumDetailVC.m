//
//  ForumDetailVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumDetailVC.h"

//Macro
//Framework
//Category
#import <UIScrollView+TLAdd.h>
//Extension
//M
//V
#import "SelectScrollView.h"
#import "ForumCircleTableView.h"
#import "TLTableView.h"
//C
#import "ForumCircleChildVC.h"
#import "ForumInfoChildVC.h"
#import "ForumQuotesChildVC.h"

@interface ForumDetailVC ()<UIScrollViewDelegate>
//币吧数据
//币吧说明
//币吧具体数据

//滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;
//
@property (nonatomic, strong) SelectScrollView *selectScrollView;
//标题
@property (nonatomic, strong) NSArray *titles;
//
@property (nonatomic, assign) BOOL canScroll;
//vcCanScroll
@property (nonatomic, assign) BOOL vcCanScroll;

@end

@implementation ForumDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"币吧";
    
    //
    [self initScrollView];
    //圈子、资讯和行情
    [self initSelectScrollView];
    //添加子控制器
    [self addSubViewController];
}

#pragma mark - Init
- (void)initScrollView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kBottomInsetHeight)];
    
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = kBackgroundColor;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.scrollView adjustsContentInsets];
    
    [self.view addSubview:self.scrollView];
}

- (void)initSelectScrollView {
    
    self.titles = @[@"圈子", @"资讯", @"行情"];
    
    self.selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0 + 10, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight - kBottomInsetHeight) itemTitles:self.titles];
    
    self.selectScrollView.selectBlock = ^{
        
    };
    
    [self.scrollView addSubview:self.selectScrollView];
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        if (i == 0) {
            
            ForumCircleChildVC *childVC = [[ForumCircleChildVC alloc] init];
            
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight - kBottomInsetHeight);
            
            [self addChildViewController:childVC];
            
            [_selectScrollView.scrollView addSubview:childVC.view];
        } else if (i == 1) {
            
            ForumInfoChildVC *childVC = [[ForumInfoChildVC alloc] init];
            
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight - kBottomInsetHeight);
            
            [self addChildViewController:childVC];
            
            [_selectScrollView.scrollView addSubview:childVC.view];
        } else {
            
            ForumQuotesChildVC *childVC = [[ForumQuotesChildVC alloc] init];
            
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight - kBottomInsetHeight);
            
            [self addChildViewController:childVC];
            
            [_selectScrollView.scrollView addSubview:childVC.view];
        }
        
        
    }
    
    //转移手势
    ForumCircleTableView *tableView = (ForumCircleTableView *)[self.view viewWithTag:1800];
    
    UIPanGestureRecognizer *panGR = tableView.panGestureRecognizer;
    
    [self.scrollView addGestureRecognizer:panGR];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.selectScrollView.yy+ 1000);
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat bottomOffset = self.selectScrollView.y;
    
    CGFloat scrollOffset = scrollView.contentOffset.y;
    
    //子视图已经到顶部
    if (
        scrollOffset >= bottomOffset) {
        
        //当视图到达顶部时，使视图悬停
        scrollView.contentOffset = CGPointMake(0, bottomOffset);
        
        if (self.canScroll) {
            
            self.canScroll = NO;
            self.vcCanScroll = YES;
        }
        
        //转移手势
        TLTableView *tableView = (TLTableView *)[self.view viewWithTag:1800+self.selectScrollView.selectIndex];
        
        UIPanGestureRecognizer *panGR = tableView.panGestureRecognizer;
        
        [scrollView addGestureRecognizer:panGR];
        
    } else {
        
        //处理tableview和scrollView同时滚的问题（当vc不能滚动时，设置scrollView悬停）
        if (!self.canScroll) {
            
            scrollView.contentOffset = CGPointMake(0, bottomOffset);
        }
    }
    
    self.scrollView.showsVerticalScrollIndicator = _canScroll ? YES: NO;
}

- (void)setVcCanScroll:(BOOL)vcCanScroll {
    
    for (ForumCircleChildVC *vc in self.childViewControllers) {
        
        vc.vcCanScroll = vcCanScroll;
    }
    
    for (ForumInfoChildVC *vc in self.childViewControllers) {
        
        vc.vcCanScroll = vcCanScroll;
    }
    
    for (ForumQuotesChildVC *vc in self.childViewControllers) {
        
        vc.vcCanScroll = vcCanScroll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
