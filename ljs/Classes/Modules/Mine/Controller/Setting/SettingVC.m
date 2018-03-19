//
//  SettingVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "SettingVC.h"
//Macro
#import "AppMacro.h"
#import "APICodeMacro.h"
//Category
#import "TLAlert.h"
#import "NSString+Check.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
//M
#import "SettingGroup.h"
#import "SettingModel.h"
//V
#import "SettingTableView.h"
#import "SettingCell.h"
#import "CustomTabBar.h"
#import "BaseView.h"
//C
#import "TLChangeMobileVC.h"
#import "TLPwdRelatedVC.h"
#import "NavigationController.h"
#import "TLUserLoginVC.h"
#import "ZHAddressChooseVC.h"

@interface SettingVC ()

@property (nonatomic, strong) SettingGroup *group;

@property (nonatomic, strong) UIButton *loginOutBtn;

@property (nonatomic, strong) SettingTableView *tableView;
//
@property (nonatomic, strong) BaseView *headerView;
//头像
@property (nonatomic,strong) UIImageView *photoIV;
//
@property (nonatomic, strong) UILabel *textLbl;
//右箭头
@property (nonatomic, strong) UIImageView *rightArrowIV;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"个人设置";
    //
    [self setGroup];
    //
    [self initTableView];
    //
    [self initHeaderView];

}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[SettingTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStyleGrouped];
    
    self.tableView.group = self.group;
    
    [self.view addSubview:self.tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    
    [footerView addSubview:self.loginOutBtn];
    
    self.tableView.tableFooterView = footerView;
    
}

- (void)initHeaderView {
    
    self.headerView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 88)];
    
    self.headerView.userInteractionEnabled = YES;
    self.headerView.backgroundColor = kWhiteColor;
    //头像
    [self.headerView addSubview:self.photoIV];
    //text
    [self.headerView addSubview:self.textLbl];
    //右箭头
    [self.headerView addSubview:self.rightArrowIV];
    
    self.tableView.tableHeaderView = self.headerView;

    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectHeadIcon:)];
    
    [self.headerView addGestureRecognizer:tapGR];
    
}

- (UIImageView *)photoIV {
    
    if (!_photoIV) {
        _photoIV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 19, 50, 50)];
        _photoIV.layer.cornerRadius = 25;
        [_photoIV sd_setImageWithURL:[NSURL URLWithString:[[TLUser user].photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
        
        _photoIV.contentMode = UIViewContentModeScaleAspectFill;
        _photoIV.clipsToBounds = YES;
    }
    
    return _photoIV;
}

- (UILabel *)textLbl {
    
    if (!_textLbl) {
        _textLbl = [UILabel labelWithFrame:CGRectMake(self.photoIV.xx + 20, self.photoIV.y, kScreenWidth - self.photoIV.xx - 20 - 20 - 30, 25)
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:kWhiteColor
                                       font:Font(14.0)
                                  textColor:kTextColor];
        _textLbl.text = @"按照等级从图片库中选择";
        _textLbl.centerY = self.photoIV.centerY;
    }
    return _textLbl;
    
}

- (UIImageView *)rightArrowIV {
    
    if (!_rightArrowIV) {
        
        CGFloat arrowW = 7;
        CGFloat arrowH = 12;
        CGFloat rightMargin = 15;
        
        _rightArrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
        
        _rightArrowIV.frame = CGRectMake(kScreenWidth - arrowW - rightMargin, 0, arrowW, arrowH);
        _rightArrowIV.contentMode = UIViewContentModeScaleAspectFit;
        _rightArrowIV.centerY = self.photoIV.centerY;
    }
    return _rightArrowIV;
}

#pragma mark - Group
- (void)setGroup {
    
    BaseWeakSelf;
    
    //修改手机号
    SettingModel *changeMobile = [SettingModel new];
    changeMobile.text = @"修改手机号";
    [changeMobile setAction:^{
        
        TLChangeMobileVC *changeMobileVC = [[TLChangeMobileVC alloc] init];
        
        [weakSelf.navigationController pushViewController:changeMobileVC animated:YES];
    }];
    
    //修改登录密码
    SettingModel *changeLoginPwd = [SettingModel new];
    changeLoginPwd.text = @"修改登录密码";
    [changeLoginPwd setAction:^{
        
        TLPwdRelatedVC *pwdRelatedVC = [[TLPwdRelatedVC alloc] initWithType:TLPwdTypeReset];
        
        pwdRelatedVC.success = ^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            });
        };
        
        [weakSelf.navigationController pushViewController:pwdRelatedVC animated:YES];
        
    }];
    //收货地址
    SettingModel *address = [SettingModel new];
    address.text = @"收货地址";
    [address setAction:^{
        
        ZHAddressChooseVC *chooseVC = [ZHAddressChooseVC new];
        
        
        [self
         .navigationController pushViewController:chooseVC animated:YES];
    }];
    
    self.group = [SettingGroup new];
    
    self.group.sections = @[@[changeMobile, changeLoginPwd, address]];
    
}

#pragma mark- 退出登录

- (UIButton *)loginOutBtn {
    
    if (!_loginOutBtn) {
        
        _loginOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 55, kScreenWidth, 45)];
        _loginOutBtn.backgroundColor = kWhiteColor;
        [_loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_loginOutBtn setTitleColor:kAppCustomMainColor forState:UIControlStateNormal];
        _loginOutBtn.layer.cornerRadius = 5;
        _loginOutBtn.clipsToBounds = YES;
        _loginOutBtn.titleLabel.font = FONT(15);
        [_loginOutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginOutBtn;
}

- (void)logout {
    
    [TLAlert alertWithTitle:@"" msg:@"是否确认退出" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        
    } confirm:^(UIAlertAction *action) {
        
        UITabBarController *tbcController = self.tabBarController;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            tbcController.selectedIndex = 0;
            
            CustomTabBar *tabBar = (CustomTabBar *)tbcController.tabBar;
            tabBar.selectedIdx = 0;
        });
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
    }];
    
    
}

#pragma mark - 选择头像
- (void)selectHeadIcon:(UITapGestureRecognizer *)tapGR {

   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
