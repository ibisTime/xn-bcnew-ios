//
//  ForumChildVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumChildVC.h"
//M
#import "ForumModel.h"
//V
#import "ForumListTableView.h"

@interface ForumChildVC ()
//
@property (nonatomic, strong) ForumListTableView *tableView;
//
@property (nonatomic, strong) NSMutableArray <ForumModel *>*forums;

@end

@implementation ForumChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    [self initTableView];
    //获取币吧列表
    [self requestForumList];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[ForumListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Data
/**
 获取币种列表
 */
- (void)requestForumList {
    
    NSMutableArray <ForumModel *>*arr = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        
        ForumModel *model = [ForumModel new];
        
        model.name = @"BTC";
        model.followNum = @"66666";
        model.postNum = @"66666";
        model.updateNum = @"66666";
        model.isFollow = i%2 == 0 ? YES: NO;
        
        [arr addObject:model];
    }
    
    self.forums = arr;
    
    self.tableView.forums = self.forums;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
