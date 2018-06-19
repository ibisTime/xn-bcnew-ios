//
//  PlateDetailVC.m
//  ljs
//
//  Created by shaojianfei on 2018/6/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlateDetailVC.h"
#import "PlateTopView.h"
#import "PlateDetailTableView.h"
#import "UIBarButtonItem+convience.h"
#import "PlateIntroduceUS.h"
@interface PlateDetailVC ()<RefreshDelegate>
@property (nonatomic ,strong) TLNetworking *help;

@property (nonatomic ,strong) PlateDetailTableView *tableView;
@property (nonatomic ,strong) PlateTopView *topView;
@property (nonatomic ,strong) UILabel *lab;
@property (nonatomic ,strong) UILabel *lab2;
@property (nonatomic ,strong) UILabel *lab3;
@property (nonatomic, strong) TLPlaceholderView*hold;


@end

@implementation PlateDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTable];
    [self.tableView beginRefreshing];
    [self requestPlatform];
    // Do any additional setup after loading the view.
}


- (void)initTable
{
    
    PlateTopView *topView = [[PlateTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    [self.view addSubview:topView];

    self.topView = topView;
    UIView *titleView = [[UIView alloc] init];
    CGFloat f1 = CGRectGetMaxY(topView.frame);
    titleView.frame = CGRectMake(0, f1+10, kScreenWidth, 34);
    [self.view addSubview:titleView];
    titleView.backgroundColor = kHexColor(@"#F5F5F5");
    
    UILabel *lab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    self.lab =lab;
    UILabel *lab2 = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    self.lab2 =lab2;

    UILabel *lab3 = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    self.lab3 =lab3;

    [titleView addSubview:lab];
    [titleView addSubview:lab2];
    [titleView addSubview:lab3];
    lab.frame = CGRectMake(10, 3, 160, 24);
    lab2.frame = CGRectMake(kScreenWidth/2+20, 3, 100, 24);
    lab3.frame = CGRectMake(kScreenWidth/2+20+100, 3, 100, 24);
  

    self.tableView = [[PlateDetailTableView alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(titleView.frame), kScreenWidth -20, kScreenHeight-CGRectGetMaxY(titleView.frame)) style:UITableViewStylePlain];
    BaseWeakSelf;
    [self.view addSubview:self.tableView];
    
    self.hold = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无数据"];
    self.tableView.placeHolderView = self.hold;

    self.tableView.refreshDelegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.pagingEnabled = false;
    [UIBarButtonItem addRightItemWithTitle:@"介绍" titleColor:kWhiteColor frame:CGRectMake(0, 0, 60, 50) vc:self action:@selector(introduceUs)];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.lab.text = @"货币/成交额(24h)";
    self.lab2.text = @"最新价";
    self.lab3.text = @"涨跌幅";
    [super viewDidAppear:animated];
}

- (void)introduceUs
{
    
    NSLog(@"介绍我们");
    PlateIntroduceUS *introduce = [PlateIntroduceUS new];
    introduce.title = self.model.name;
    introduce.content = self.model.Description;
    introduce.mineModel = self.model;
    [self.navigationController pushViewController:introduce animated:YES];
    
}
- (void)requestPlatform
{
    BaseWeakSelf;
    
    TLNetworking *helper = [[TLNetworking alloc] init];
    
    helper.code = @"628616";
    helper.showView = self.view;
   
    helper.parameters[@"code"] =self.code;
    
    
    
    self.help = helper;
    
    [helper postWithSuccess:^(id responseObject) {
        self.model = [PlateMineModel mj_objectWithKeyValues:responseObject[@"data"]];
        self.Plateforms = [plateDetailModel mj_objectArrayWithKeyValuesArray:self.model.list];
        if (self.Plateforms.count <= 0) {
            [self.tableView addSubview:self.hold];
        }
        self.topView.model = self.model;
        self.tableView.models = self.Plateforms;
        [self.tableView reloadData_tl];
        NSLog(@"%@",self.Plateforms);
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
