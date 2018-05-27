//
//  NewSearchViewController.m
//  ljs
//
//  Created by zhangfuyu on 2018/5/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "NewSearchViewController.h"
//Category
#import "UIBarButtonItem+convience.h"
#import "TLTextField.h"

#import "SelectScrollView.h"
#import "HomeChildVC.h"
#import "ActivityVC.h"
#import "PlatformAndOtherVC.h"

@interface NewSearchViewController ()<UITextFieldDelegate>
//搜索
@property (nonatomic, strong) TLTextField *searchTF;
//项目信息
@property (nonatomic, strong) SelectScrollView *selectSV;
//标题
@property (nonatomic, strong) NSArray *titles;
//币种
@property (nonatomic , strong)PlatformAndOtherVC *currencyvc;
//平台
@property (nonatomic , strong)PlatformAndOtherVC *platformvc;
//资讯
@property (nonatomic , strong)HomeChildVC *information;
//快讯
@property (nonatomic , strong)HomeChildVC *alerts;
//活动
@property (nonatomic , strong)ActivityVC *activity;
@property (nonatomic , strong)NSString *searchText;

@end

@implementation NewSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //取消
    [self addCancelItem];
    //搜索
    [self initSearchBar];
    
    //添加子控制器
    [self initSelectScrollView];
    //
    [self addSubViewController];
}
#pragma mark - Init
- (void)addCancelItem {
    
    [UIBarButtonItem addRightItemWithTitle:@"取消" titleColor:kWhiteColor frame:CGRectMake(0, 0, 35, 44) vc:self action:@selector(back)];
}

- (void)initSearchBar {
    
    [UINavigationBar appearance].barTintColor = kAppCustomMainColor;
    CGFloat height = 35;
    //搜索
    UIView *searchBgView = [[UIView alloc] init];
    //    UIView *searchBgView = [[UIView alloc] init];
    
    searchBgView.backgroundColor = kWhiteColor;
    searchBgView.userInteractionEnabled = YES;
    searchBgView.layer.cornerRadius = height/2.0;
    searchBgView.clipsToBounds = YES;
    
    self.navigationItem.titleView = searchBgView;
    
    [searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    //搜索输入框
    self.searchTF = [[TLTextField alloc] initWithFrame:CGRectZero
                                             leftTitle:@""
                                            titleWidth:0
                                           placeholder:@"请输入平台/币种"];
    self.searchTF.delegate = self;
    self.searchTF.returnKeyType = UIReturnKeySearch;
    
//    [self.searchTF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [searchBgView addSubview:self.searchTF];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 13, 0, 0));
        
        make.width.mas_greaterThanOrEqualTo(kScreenWidth - 20 - 40 -  15 - 13);
    }];
    
}

- (void)initSelectScrollView {
    
    BaseWeakSelf;
    
    self.titles = @[@"币种",@"平台",@"资讯",@"快讯",@"活动"];
    
    self.selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kBottomInsetHeight) itemTitles:self.titles];
    self.selectSV.selectBlock = ^(NSInteger index) {
        
        [weakSelf didSelectWithIndex:index];
        
    };
    [self.view addSubview:self.selectSV];
    
}

- (void)addSubViewController
{
    for (NSInteger index = 0; index < self.titles.count; index++) {
        if (index == 0) {
            self.currencyvc = [[PlatformAndOtherVC alloc]init];
            self.currencyvc.view.frame = CGRectMake(kScreenWidth*index, 1, kScreenWidth, kSuperViewHeight - kTabBarHeight);
            [self addChildViewController:self.currencyvc];
            [self.selectSV.scrollView addSubview:self.currencyvc.view];
        }
        else if (index == 1) {
            self.platformvc = [[PlatformAndOtherVC alloc]init];
            self.platformvc.view.frame = CGRectMake(kScreenWidth*index, 1, kScreenWidth, kSuperViewHeight - kTabBarHeight);
            [self addChildViewController:self.platformvc];
            [self.selectSV.scrollView addSubview:self.platformvc.view];
        }
        else if (index == 2) {
            
            self.information = [[HomeChildVC alloc] init];
            self.information.status = @"1";
            self.information.kind = @"2";
            self.information.isSearch = YES;
            self.information.view.frame = CGRectMake(kScreenWidth*index, 1, kScreenWidth, kSuperViewHeight - kTabBarHeight);
            
            [self addChildViewController:self.information];
            
            [self.selectSV.scrollView addSubview:self.information.view];
        }
        else if (index == 3) {
            self.alerts = [[HomeChildVC alloc] init];
            self.alerts.status = @"";
            self.alerts.kind = @"1";
            self.alerts.view.frame = CGRectMake(kScreenWidth*index, 1, kScreenWidth, kSuperViewHeight - kTabBarHeight);
            self.alerts.isSearch = YES;
            [self addChildViewController:self.alerts];
            
            [self.selectSV.scrollView addSubview:self.alerts.view];
        }
        else if (index == 4)
        {
            self.activity = [[ActivityVC alloc]init];
            self.activity.view.frame = CGRectMake(kScreenWidth*index, 1, kScreenWidth, kSuperViewHeight - kTabBarHeight);
            self.activity.isSearch = YES;
            [self addChildViewController:self.activity];
            [self.selectSV.scrollView addSubview:self.activity.view];

        }
    }
}
//UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    int index = self.selectSV.scrollView.contentOffset.x / kScreenWidth;
    [textField resignFirstResponder];

    switch (index) {
        case 0:
            [self.platformvc searchRequestWith:textField.text];

            break;
        case 1:
            [self.currencyvc searchRequestWith:textField.text];

            break;
        case 2:
            [self.information searchRequestWith:textField.text];

            break;
        case 3:
            [self.alerts searchRequestWith:textField.text];

            break;
        case 4:
            [self.activity searchRequestWith:textField.text];

            break;
            
        default:
            break;
    }
    
    return YES;
}
/**
 切换标签
 */
- (void)didSelectWithIndex:(NSInteger)index
{
 

}
- (void)back {
    
    [self.searchTF resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
