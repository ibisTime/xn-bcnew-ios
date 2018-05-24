//
//  CurrentesManagementVC.m
//  ljs
//
//  Created by zhangfuyu on 2018/5/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrentesManagementVC.h"
#import "TLTextField.h"
#import "UIBarButtonItem+convience.h"

@interface CurrentesManagementVC ()
//搜索
@property (nonatomic, strong) TLTextField *searchTF;
@end

@implementation CurrentesManagementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //取消
    [self addCancelItem];
    //搜索
    [self initSearchBar];
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
                                           placeholder:@"栏目搜索"];
    self.searchTF.delegate = self;
    self.searchTF.returnKeyType = UIReturnKeySearch;
    
    [self.searchTF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [searchBgView addSubview:self.searchTF];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 13, 0, 0));
        
        make.width.mas_greaterThanOrEqualTo(kScreenWidth - 20 - 40 -  15 - 13);
    }];
    
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
