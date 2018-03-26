//
//  MineVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MineVC.h"
//Manager
#import "TLUploadManager.h"
//Macro
#import "APICodeMacro.h"
#import "AppMacro.h"
//Category
#import "NSString+Extension.h"
#import "UIBarButtonItem+convience.h"
//Extension
#import <UIImageView+WebCache.h>
#import "TLProgressHUD.h"
#import "NSString+Check.h"
//M
#import "MineGroup.h"
//V
#import "MineTableView.h"
#import "MineHeaderView.h"
#import "TLImagePicker.h"
#import "BaseView.h"
//C
#import "SettingVC.h"
#import "HTMLStrVC.h"
#import "NavigationController.h"
#import "TLUserLoginVC.h"
#import "UserDetailEditVC.h"
#import "InfoCommentVC.h"
#import "CircleCommentVC.h"
#import "MyCollectionListVC.h"

@interface MineVC ()<MineHeaderSeletedDelegate>
//模型
@property (nonatomic, strong) MineGroup *group;
//退出登录
@property (nonatomic, strong) BaseView *logoutView;
//
@property (nonatomic, strong) MineTableView *tableView;
//头部
@property (nonatomic, strong) MineHeaderView *headerView;
//选择头像
@property (nonatomic, strong) TLImagePicker *imagePicker;

@end

@implementation MineVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    //item
    [self addEditItem];
    //通知
    [self addNotification];
    //
    [self initTableView];
    //模型
    [self initGroup];
    //
    [self changeInfo];
    
}

#pragma mark - Init
- (void)addEditItem {
    
    [UIBarButtonItem addRightItemWithTitle:@"编辑"
                                titleColor:kWhiteColor
                                     frame:CGRectMake(0, 0, 60, 40)
                                        vc:self
                                    action:@selector(editInfo)];
}

- (BaseView *)logoutView {
    
    if (!_logoutView) {
        
        _logoutView = [[BaseView alloc] initWithFrame:CGRectMake(0, 35, kScreenWidth, 100)];
        
        UIButton *logoutBtn = [UIButton buttonWithTitle:@"退出登录"
                                             titleColor:kThemeColor
                                        backgroundColor:kWhiteColor
                                              titleFont:18.0];
        
        [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];

        [_logoutView addSubview:logoutBtn];
        [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(@0);
            make.top.equalTo(@35);
            make.height.equalTo(@60);
        }];
    }
    return _logoutView;
}

- (void)initGroup {
    
    BaseWeakSelf;
    
    //收藏
    MineModel *collection = [MineModel new];
    
    collection.text = @"收藏";
    collection.imgName = @"收藏";
    collection.action = ^{
        
        [weakSelf checkLogin:^{
            
            MyCollectionListVC *collectionVC = [MyCollectionListVC new];
            
            [weakSelf.navigationController pushViewController:collectionVC animated:YES];
        }];
    };
    
    //圈子评论
    MineModel *forumComment = [MineModel new];
    
    forumComment.text = @"圈子评论";
    forumComment.imgName = @"圈子评论";
    forumComment.action = ^{
        
        [weakSelf checkLogin:^{
            
            CircleCommentVC *commentVC = [CircleCommentVC new];
            
            [weakSelf.navigationController pushViewController:commentVC animated:YES];
        }];
    };
    //资讯评论
    MineModel *infoComment = [MineModel new];
    
    infoComment.text = @"资讯评论";
    infoComment.imgName = @"资讯评论";
    infoComment.action = ^{
        
        [weakSelf checkLogin:^{
            
            InfoCommentVC *commentVC = [InfoCommentVC new];
            
            commentVC.type = MyCommentTypeInfo;

            [weakSelf.navigationController pushViewController:commentVC animated:YES];
        }];
    };
    
    //关于
    MineModel *aboutUs = [MineModel new];
    
    aboutUs.text = @"关于";
    aboutUs.imgName = @"关于";
    aboutUs.action = ^{
        
        HTMLStrVC *htmlVC = [[HTMLStrVC alloc] init];
        
        htmlVC.type = HTMLTypeAboutUs;
        
        [weakSelf.navigationController pushViewController:htmlVC animated:YES];
    };
    //清除缓存
    MineModel *cache = [MineModel new];
    
    cache.text = @"清除缓存";
    cache.action = ^{
        
    };
    
    self.group = [MineGroup new];
    
    self.group.sections = @[@[collection, forumComment, infoComment, aboutUs, cache]];
    
    self.tableView.mineGroup = self.group;
    
    [self.tableView reloadData];
}

- (void)initTableView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = kImage(@"我的-背景");
    
    imageView.tag = 1500;
    imageView.backgroundColor = kAppCustomMainColor;
    
    [self.view addSubview:imageView];
    
    self.tableView = [[MineTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    
    self.tableView.tableFooterView = self.logoutView;

    [self.view addSubview:self.tableView];
    
    //tableview的header
    self.headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    
    self.headerView.delegate = self;
    
    self.tableView.tableHeaderView = self.headerView;

}

- (TLImagePicker *)imagePicker {
    
    if (!_imagePicker) {
        
        BaseWeakSelf;
        
        _imagePicker = [[TLImagePicker alloc] initWithVC:self];
        
        _imagePicker.allowsEditing = NO;
        _imagePicker.clipHeight = kScreenWidth;
        
        _imagePicker.pickFinish = ^(UIImage *photo, NSDictionary *info){
            
            UIImage *image = info == nil ? photo: info[@"UIImagePickerControllerOriginalImage"];
            
            NSData *imgData = UIImageJPEGRepresentation(image, 0.1);
            
            //进行上传
            [TLProgressHUD show];
            
            TLUploadManager *manager = [TLUploadManager manager];
            
            manager.imgData = imgData;
            manager.image = image;
            
            [manager getTokenShowView:weakSelf.view succes:^(NSString *key) {
                
                [weakSelf changeHeadIconWithKey:key imgData:imgData];
                
            } failure:^(NSError *error) {
                
            }];
        };
    }
    
    return _imagePicker;
}

#pragma mark - Notification
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserInfoChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
}

#pragma mark - Events
- (void)changeInfo {
    //
    [self.headerView.userPhoto sd_setImageWithURL:[NSURL URLWithString:[[TLUser user].photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    
    if (![TLUser user].isLogin) {
        
        [self.headerView.nameBtn setTitle:@"快速登录" forState:UIControlStateNormal];
        self.tableView.tableFooterView.hidden = YES;
        
    } else {
        
        [self.headerView.nameBtn setTitle:[TLUser user].nickname forState:UIControlStateNormal];

        self.tableView.tableFooterView.hidden = NO;
    }
}

- (void)loginOut {
    
    [self.headerView.nameBtn setTitle:@"快速登录" forState:UIControlStateNormal];

    self.headerView.userPhoto.image = USER_PLACEHOLDER_SMALL;
}

/**
 编辑资料
 */
- (void)editInfo {
    
    BaseWeakSelf;
    
    [self checkLogin:^{
        
        UserDetailEditVC *editVC = [UserDetailEditVC new];
        
        [weakSelf.navigationController pushViewController:editVC animated:YES];
    }];
}

/**
 判断用户是否登录
 */
- (void)checkLogin:(void(^)(void))loginSuccess {
    
    if(![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [TLUserLoginVC new];
        
        loginVC.loginSuccess = loginSuccess;
        
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        return ;
    }
    
    if (loginSuccess) {
        
        loginSuccess();
    }
}

- (void)logout {
    
    [TLAlert alertWithTitle:@"" msg:@"是否确认退出" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        
    } confirm:^(UIAlertAction *action) {
        
        self.tableView.tableFooterView.hidden = YES;

        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
    }];
    
}

#pragma mark - Data
- (void)changeHeadIconWithKey:(NSString *)key imgData:(NSData *)imgData {
    
    TLNetworking *http = [TLNetworking new];
    
    //    http.showView = self.view;
    http.code = USER_CHANGE_USER_PHOTO;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"photo"] = key;
    http.parameters[@"token"] = [TLUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        [TLProgressHUD dismiss];
        
        [TLAlert alertWithSucces:@"修改头像成功"];
        
        [TLUser user].photo = key;
        //替换头像
        [self.headerView.userPhoto sd_setImageWithURL:[NSURL URLWithString:[key convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - MineHeaderSeletedDelegate
- (void)didSelectedWithType:(MineHeaderSeletedType)type idx:(NSInteger)idx {
    
    switch (type) {
        case MineHeaderSeletedTypeLogin:
        {
            [self checkLogin:nil];
        }break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
