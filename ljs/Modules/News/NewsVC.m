//
//  NewsVC.m
//  ljs
//
//  Created by 郑勤宝 on 2019/10/30.
//  Copyright © 2019 caizhuoyue. All rights reserved.
//

#import "NewsVC.h"
#import "SelectScrollView.h"
#import "HomeChildVC.h"
#import "NewsFlashModel.h"
@interface NewsVC ()

@property (nonatomic , strong)NSArray *titles;

@end

@implementation NewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"快讯";
    self.titles = @[@"全部",@"热点"];
    [self initScrollView];
}

-(void)initScrollView
{
    SelectScrollView *selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) itemTitles:@[@"全部",@"热点"]];
    selectSV.tag = 2500;
    [self.view addSubview:selectSV];
    [self addSubViewController:0];
}

- (void)addSubViewController:(NSInteger)index {
    
    SelectScrollView *selectSV = (SelectScrollView *)[self.view viewWithTag:2500];
    
    for (NSInteger i = 0; i < 2; i++) {
        NSArray *statusList = @[kAllNewsFlash, kHotNewsFlash];
        HomeChildVC *childVC = [[HomeChildVC alloc] init];
        childVC.status = statusList[i];
        childVC.kind = @"1";
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight);
        [self addChildViewController:childVC];
        [selectSV.scrollView addSubview:childVC.view];
        
    }
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
