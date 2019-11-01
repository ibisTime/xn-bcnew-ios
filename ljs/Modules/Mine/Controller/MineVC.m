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
#import <MBProgressHUD.h>
//M
#import "MineGroup.h"
//V
#import "MineTableView.h"
#import "MineHeaderView.h"
#import "TLImagePicker.h"
#import "BaseView.h"
//C
#import "HTMLStrVC.h"
#import "NavigationController.h"
#import "TLUserLoginVC.h"
#import "UserDetailEditVC.h"
#import "InfoCommentVC.h"
#import "CircleCommentVC.h"
#import "MyCollectionListVC.h"
#import "TakeActivityVCr.h"
#import "MyArticleViewController.h"
#import "Html5Vc.h"
#import "HomePageInfoVC.h"
#import "MineCenterViewController.h"
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
@property (nonatomic, strong)  UIImageView *imageView;
@property (nonatomic, strong)  UITapGestureRecognizer *tapGR;


@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的";
    //通知
    [self addNotification];
    //
    [self initTableView];
    
    //列表内容及对应点开内容  模型
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
//
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
    
   
    //资讯评论
//    MineModel *infoComment = [MineModel new];
//
//    infoComment.text = @"评论";
//    infoComment.imgName = @"评论";
//    infoComment.action = ^{
//
//        [weakSelf checkLogin:^{
//
//            InfoCommentVC *commentVC = [InfoCommentVC new];
//
//            [weakSelf.navigationController pushViewController:commentVC animated:YES];
//        }];
//    };
//    //圈子评论
//   MineModel *forumComment = [MineModel new];
//    forumComment.text = @"我参与的活动";
//    forumComment.imgName = @"参加的活动";
//    forumComment.action = ^{
//
//        [weakSelf checkLogin:^{
//
////            CircleCommentVC *commentVC = [CircleCommentVC new];
//            TakeActivityVCr *takeVc = [TakeActivityVCr new];
//            takeVc.view.frame = CGRectMake(0, 0, 375, 667);
//            takeVc.view.backgroundColor = kBackgroundColor;
//            [weakSelf.navigationController pushViewController:takeVc animated:YES];
//        }];
//    };
//    //清除缓存
//    MineModel *cache = [MineModel new];
//
//    cache.text = @"我的文章";
////    cache.isSpecial = YES;
//    cache.imgName = @"我的文章";
//
////    cache.isHiddenArrow = YES;
//    cache.action = ^{
//
//        [self checkLogin:^{
//            MyArticleViewController *myArticle = [[MyArticleViewController alloc] init];
//            [self.navigationController pushViewController:myArticle animated:YES];
//        }];
//
//    };
    
    //关于
    MineModel *aboutUs = [MineModel new];
    
    aboutUs.text = @"关于";
    aboutUs.imgName = @"关于";
    aboutUs.action = ^{
        
        Html5Vc *htmlVC = [[Html5Vc alloc] init];
        
        htmlVC.type = HTMLTypeAboutUs;
        
        [weakSelf.navigationController pushViewController:htmlVC animated:YES];
    };
   
    self.group = [MineGroup new];
    
//    self.group.sections = @[@[collection, forumComment, infoComment, aboutUs, cache]];
    self.group.sections = @[@[collection, aboutUs]];

    
    self.tableView.mineGroup = self.group;
    
    [self.tableView reloadData];
}

- (void)initTableView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    self.imageView = imageView;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = kImage(@"我的-背景");
    imageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookArticle:)];
//    self.tapGR = tapGR;
//    [imageView addGestureRecognizer:tapGR];
    imageView.tag = 1500;
    imageView.backgroundColor = kAppCustomMainColor;
    UIView*view = [[UIControl alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,110)] ;
    view.backgroundColor = [UIColor clearColor];
    [(UIControl *)view addTarget:self action:@selector(lookArticle) forControlEvents:UIControlEventTouchUpInside];
   
    [view addSubview:imageView];
    [self.view addSubview:view];
//    [self.view addSubview:imageView];
    
    self.tableView = [[MineTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    
    self.tableView.tableFooterView = self.logoutView;

    [self.view addSubview:self.tableView];
    
    //tableview的header
    self.headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    
    self.headerView.delegate = self;
    
    self.tableView.tableHeaderView = self.headerView;

}

- (void)lookArticle
{
    
    NSLog(@"点击头像");
    
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [self changeInfo];
    // 设置导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[kAppCustomMainColor convertToImage] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Notification
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserInfoChange object:nil];
    //接收通知退出登入
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
}

#pragma mark - Events
- (void)changeInfo {
    //
    [self.headerView.userPhoto sd_setImageWithURL:[NSURL URLWithString:[[TLUser user].photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    
    if (![TLUser user].isLogin) {
        
        [self.headerView.nameBtn setTitle:@"快速登录" forState:UIControlStateNormal];
        self.tableView.tableFooterView.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
        
    } else {
        [self.headerView.nameBtn setTitle:[TLUser user].nickname forState:UIControlStateNormal];

        self.tableView.tableFooterView.hidden = NO;
        //编辑
        [self addEditItem];
    }
}

- (void)loginOut {
    
    [self.headerView.nameBtn setTitle:@"快速登录" forState:UIControlStateNormal];

    self.headerView.userPhoto.image = USER_PLACEHOLDER_SMALL;
    self.navigationItem.rightBarButtonItem = nil;
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
      //发布通知要退出了
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
    }];
    
}

/**
 清除缓存
 */
- (void)clearCache {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.size = CGSizeMake(100, 100);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[SDImageCache sharedImageCache] clearDisk];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            hud.mode = MBProgressHUDModeAnnularDeterminate;
            hud.labelText = @"清除中...";
            
        });
        
        float progress = 0.0f;
        
        while (progress < 1.0f) {
            
            progress += 0.02f;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                hud.progress = progress;
            });
            usleep(50000);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image = [UIImage imageNamed:@"clear_complete"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            
            imageView.frame = CGRectMake(0, 0, 35, 35);
            
            hud.customView = imageView;
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"清除完成";
            
            [_tableView reloadData];
            
            [hud hide:YES afterDelay:1];
        });
        
    });
    
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
        case MineHeaderSeletedTypeDefault:
        {
//            [self checkLogin:^{
//                [self goUserDetail];
//
//            }];
            NSLog(@"点击了头像");
        }break;
            
        default:
            break;
    }
}


- (void)goUserDetail {
    
    
    if (![TLUser user].userId) {
        [TLAlert alertWithError:@"无 userId"];
        return;
    }else{
    
    
        MineCenterViewController *pageVC = [[MineCenterViewController alloc] init];
        
        pageVC.userId = [TLUser user].userId;
        
        [self.navigationController pushViewController:pageVC animated:YES];
        return ;
    
    }
}
/**
 VC被释放时移除通知
 */
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
