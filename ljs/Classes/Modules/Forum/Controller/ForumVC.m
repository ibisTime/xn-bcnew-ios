//
//  ForumVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumVC.h"
//Category
#import "UIBarButtonItem+convience.h"
//M
#import "ForumModel.h"
//V
#import "SelectScrollView.h"
//C
#import "ForumChildVC.h"

@interface ForumVC ()
//滚动
@property (nonatomic, strong) SelectScrollView *selectSV;
//
@property (nonatomic, strong) NSArray *titles;
//
@property (nonatomic, strong) NSArray *statusList;

@end

@implementation ForumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"币吧";
    
    [self initSelectScrollView];
    //
    [self addSubViewController];
    //
    [self addItem];
    
}

#pragma mark - Init

- (void)addItem {
    
    //搜索
    [UIBarButtonItem addRightItemWithImageName:@"搜索" frame:CGRectMake(0, 0, 40, 40) vc:self action:@selector(search)];
}

- (void)initSelectScrollView {
    
    self.titles = @[@"全部", @"热门", @"关注"];
    
    self.statusList = @[kAllPost, kHotPost, kFoucsPost];

    SelectScrollView *selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) itemTitles:self.titles];
    
    [self.view addSubview:selectSV];
    
    self.selectSV = selectSV;
    
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        ForumChildVC *childVC = [[ForumChildVC alloc] init];
        
        childVC.status = self.statusList[i];
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight);
        
        [self addChildViewController:childVC];
        
        [self.selectSV.scrollView addSubview:childVC.view];
        
    }
}

#pragma mark - Events
- (void)search {
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
