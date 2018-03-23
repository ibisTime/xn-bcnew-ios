//
//  ForumCircleChildVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumCircleChildVC.h"
//V
#import "ForumCircleTableView.h"

@interface ForumCircleChildVC ()<RefreshDelegate>
//圈子
@property (nonatomic, strong) ForumCircleTableView *tableView;

@end

@implementation ForumCircleChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //圈子
    [self initTableView];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[ForumCircleTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.refreshDelegate = self;
    
    self.tableView.tag = 1800 + self.index;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
