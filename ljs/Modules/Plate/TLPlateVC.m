//
//  TLPlateVC.m
//  ljs
//
//  Created by shaojianfei on 2018/6/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLPlateVC.h"
#import "PlatformTableView.h"
#import "TLTopCollectionView.h"
#import "PlateTableView.h"
#import "PlateDetailVC.h"
@interface TLPlateVC ()<RefreshDelegate>
@property (nonatomic, strong) PlateTableView *tableView;
@property (nonatomic, strong) TLTopCollectionView *topView;

@property (nonatomic, strong) TLPageDataHelper *help;

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UIView *bottomLine;


@end

@implementation TLPlateVC

- (void)viewDidLoad {
    self.title = @"板块";
    self.view.backgroundColor = kWhiteColor;
    [super viewDidLoad];
    [self initCollection];
    [self initTableView];

    [self requestPlatform];
    [self requestBottom];
    [self.tableView beginRefreshing];
    
    // Do any additional setup after loading the view.
}
- (void)initTableView {
    
   
    
    //       self.tableView.tableHeaderView = self.headerView;
    
    
    
    
}
- (void)initCollection
{
    
    
    UILabel *lable = [UILabel labelWithTitle:@"热门板块" frame:CGRectMake(10, 10, kScreenWidth -30, 30)];
    lable.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:lable];
    lable.font = [UIFont systemFontOfSize:17.0];
    lable.textColor = kTextColor;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lable.frame)+5, kScreenWidth-30, 2)];
    self.topLine = line;
    [self.view addSubview:line];
    line.backgroundColor = kLineColor;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 80);
    layout.minimumLineSpacing = 10.0; // 竖
    layout.minimumInteritemSpacing = 10.0; // 横
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    UIImage *image1 = [UIImage imageNamed:@"金"];
    UIImage *image2 = [UIImage imageNamed:@"银"];
    UIImage *image3 = [UIImage imageNamed:@"铜"];
    NSArray *array = @[image2, image2, image3, image2, image3, image1, image3, image1, image1];
    
    TLTopCollectionView *topView = [[TLTopCollectionView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, 200-35) collectionViewLayout:layout withImage:array];
    self.topView = topView;
    [self.view addSubview:topView];
    
    UIView *lineView = [[UIView alloc] init];
    self.bottomLine = lineView;
    CGFloat f = CGRectGetMaxY(topView.frame);
    lineView.frame = CGRectMake(0, f, kScreenWidth, 10);
    [self.view addSubview:lineView];
    lineView.backgroundColor = kHexColor(@"#F5F5F5");
    
    
    UILabel *lable1 = [UILabel labelWithTitle:@"全部板块" frame:CGRectMake(15, CGRectGetMaxY(lineView.frame), kScreenWidth -30, 30)];
    lable1.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:lable1];
    lable1.font = [UIFont systemFontOfSize:17.0];
    lable1.textColor = kTextColor;
    
    
    UIView *titleView = [[UIView alloc] init];
    CGFloat f1 = CGRectGetMaxY(lable1.frame);
    titleView.frame = CGRectMake(0, f1+5, kScreenWidth, 34);
    [self.view addSubview:titleView];
    titleView.backgroundColor = kHexColor(@"#F5F5F5");
    
    UILabel *lab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    
    UILabel *lab2 = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    UILabel *lab3 = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    [titleView addSubview:lab];
    [titleView addSubview:lab2];
    [titleView addSubview:lab3];
    lab.frame = CGRectMake(10, 3, 100, 24);
    lab2.frame = CGRectMake(kScreenWidth/2+20, 3, 100, 24);
    lab3.frame = CGRectMake(kScreenWidth/2+20+100, 3, 100, 24);
    lab.text = @"概念";
    lab2.text = @"最佳/最差";
    lab3.text = @"涨跌幅";


    self.tableView = [[PlateTableView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleView.frame), kScreenWidth -30, 250) style:UITableViewStylePlain];
    BaseWeakSelf;
    [self.view addSubview:self.tableView];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无平台"];
    self.tableView.refreshDelegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.pagingEnabled = false;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self requestPlatform];
    [super viewWillAppear:animated];
    
}

- (void)requestPlatform
{
    BaseWeakSelf;

    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628615";
    helper.showView = self.view;
   
    helper.parameters[@"start"] = @"0";
    helper.parameters[@"limit"] = @"10";
    helper.parameters[@"location"] = @"1";

    
    helper.tableView = self.tableView;
    [helper modelClass:[PlateMineModel class]];
    
    self.help = helper;
    
    
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:6];

            for (int i =  0 ; i<6; i++) {
                [temp addObject:objs[i]];

            }
            weakSelf.Plateforms = temp;
            weakSelf.topView.models = temp;
            [weakSelf.topView reloadData];
            NSLog(@"%@",objs);
            
        } failure:^(NSError *error) {
            
        }];
    
}

- (void)requestBottom
{
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628615";
    helper.showView = self.view;
    
    helper.parameters[@"start"] = @"0";
    helper.parameters[@"limit"] = @"10";
    helper.parameters[@"location"] = @"0";
    
    
    helper.tableView = self.tableView;
    [helper modelClass:[PlateMineModel class]];
    
    self.help = helper;
    
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:6];
        
        weakSelf.bottomPlateforms = objs;
        weakSelf.tableView.models= objs;
        
        [weakSelf.tableView reloadData_tl];
        NSLog(@"%@",objs);
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PlateMineModel *model = self.Plateforms[indexPath.row];
    PlateDetailVC *detail = [PlateDetailVC new];
    detail.code = model.code;
    detail.title = model.name;
    [self.navigationController pushViewController:detail animated:YES];
    
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
