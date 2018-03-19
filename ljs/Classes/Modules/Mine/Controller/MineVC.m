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
//C
#import "SettingVC.h"
#import "HTMLStrVC.h"

@interface MineVC ()<MineHeaderSeletedDelegate>
//模型
@property (nonatomic, strong) MineGroup *group;
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
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self initGroup];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    //通知
    [self addNotification];
    //
    [self initTableView];
    //
    [self changeInfo];
    
}

#pragma mark - Init

- (void)initGroup {
    
    BaseWeakSelf;
    
    //收藏
    MineModel *collection = [MineModel new];
    
    collection.text = @"收藏";
    collection.imgName = @"收藏";
    collection.action = ^{
        
    
    };
    
    //评论
    MineModel *comment = [MineModel new];
    
    comment.text = @"评论";
    comment.imgName = @"评论";
    comment.action = ^{
        
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
    
    self.group = [MineGroup new];
    
    self.group.sections = @[@[collection, comment, aboutUs]];
    
    self.tableView.mineGroup = self.group;
    
    [self.tableView reloadData];
}

- (void)initTableView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110 + kNavigationBarHeight)];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = kImage(@"我的-背景");
    
    imageView.tag = 1500;
    
    [self.view addSubview:imageView];
    
    self.tableView = [[MineTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    
    [self.view addSubview:self.tableView];
    
    //tableview的header
    self.headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110 + kNavigationBarHeight)];
    
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
    
    self.headerView.nameLbl.text = [TLUser user].realName;
}

- (void)loginOut {
    
    self.headerView.nameLbl.text = @"";
    
    self.headerView.userPhoto.image = USER_PLACEHOLDER_SMALL;
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
        case MineHeaderSeletedTypeDefault:
        {
            SettingVC *settingVC = [SettingVC new];
            
            [self.navigationController pushViewController:settingVC animated:YES];
            
        }break;
            
            //        case MineHeaderSeletedTypeSelectPhoto:
            //        {
            //            [self.imagePicker picker];
            //
            //        }break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
