//
//  UserDetailEditVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "UserDetailEditVC.h"
//Macro
#import "APICodeMacro.h"
//Framework
//Category
#import "UIBarButtonItem+convience.h"
#import "NSString+Date.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
//Extension
#import "TLProgressHUD.h"
#import "TLImagePicker.h"
#import "TLDatePicker.h"
#import "QNUploadManager.h"
#import "TLUploadManager.h"
#import "QNResponseInfo.h"
#import "QNConfiguration.h"
//M
#import "UserEditModel.h"
//V
#import "UserEditCell.h"
#import "TLTextView.h"
#import "TLTableView.h"
//C
#import "EditVC.h"

@interface UserDetailEditVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSArray *models;

@property (nonatomic, strong) TLImagePicker *imagePicker;
@property (nonatomic, strong) TLTableView *tableView;
@property (nonatomic, strong) TLDatePicker *datePicker;

@end

@implementation UserDetailEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑资料";
    //
    [self initTableView];
    //模型
    [self initGroup];
}

#pragma mark - Init

- (void)initTableView {
    
    self.tableView = [[TLTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)initGroup {
    
    //
    UserEditModel *photoModel = [UserEditModel new];
    
    photoModel.title = @"头像";
    
    photoModel.url = [TLUser user].photo ? [[TLUser user].photo convertImageUrl]: @"没有头像";
    
    //昵称
    UserEditModel *nickNameModel = [UserEditModel new];
    nickNameModel.title = @"昵称";
    nickNameModel.content = [TLUser user].nickname;
    
    //生日
    UserEditModel *birthdayModel = [UserEditModel new];
    birthdayModel.title = @"生日";
    birthdayModel.content =  [TLUser user].birthday ? [TLUser user].birthday : @"请选择生日";
    
    //性别
    UserEditModel *sexModel = [UserEditModel new];
    sexModel.title = @"性别";
    if ([TLUser user].gender) {
        
        sexModel.content = [[TLUser user].gender isEqualToString:@"1"] ? @"男" : @"女";
        
    } else {
        
        sexModel.content = @"请选择性别";
    }
    
    self.models = @[@[photoModel,nickNameModel,sexModel,birthdayModel]];
}

/**
 时间选择器
 */
- (TLDatePicker *)datePicker {
    
    if (!_datePicker) {
        
        BaseWeakSelf;
        _datePicker = [TLDatePicker new];
        _datePicker.datePicker.datePickerMode = UIDatePickerModeDate;
        
        NSDate *loaclDate = [[NSDate alloc] init];
        
        NSString *loaclStr = [NSString stringFromDate:loaclDate formatter:@"yyyy-MM-dd"];
        
        NSString *monthStr = [NSString stringFromDate:loaclDate formatter:@"MM-dd"];
        
        NSString *yearStr = [loaclStr substringToIndex:4];
        
        NSString *dateStr = [NSString stringWithFormat:@"%ld-%@", yearStr.integerValue - 100, monthStr];
        
        NSDate *minDate = [NSString dateFromString:dateStr formatter:@"yyyy-MM-dd"];
        
        _datePicker.datePicker.minimumDate = minDate;
        _datePicker.datePicker.maximumDate = loaclDate;
        
        [_datePicker.datePicker setDate:loaclDate animated:YES];
        
        [_datePicker setConfirmAction:^(NSDate *date) {
            
            NSArray <UserEditModel *>*arr = weakSelf.models[0];
            
            UserEditModel *editModel = arr[3];
            
            editModel.content =  [NSString stringFromDate:date formatter:@"yyyy-MM-dd"];
            
            [weakSelf changeBirthDay:editModel.content];
        }];
    }
    return _datePicker;
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
        NSArray <UserEditModel *>*arr = self.models[0];
        
        arr[0].url = key;
        
        [self.tableView reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Data
/**
 修改性别
 */
- (void)changeGender:(NSString *)gender {
    
    NSString *sex = [gender isEqualToString:@"男"] ? @"1" : @"2";
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805085";
    http.parameters[@"gender"] = sex;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"修改成功"];
        
        [self.tableView reloadData];
        
        TLUser *user = [TLUser user];
        user.gender = sex;
        [[TLUser user] updateUserInfo];
        //发出用户信息变更通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 修改生日
 */
- (void)changeBirthDay:(NSString *)birthDay {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805086";
    http.parameters[@"birthday"] = birthDay;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"修改成功"];
        
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - datePicker
- (void)dateChange:(UIDatePicker *)datePicker {
    
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.models.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = self.models[section];
    
    return arr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserEditCellId"];
    if (!cell) {
        
        cell = [[UserEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserEditCellId"];
        
    }
    NSArray <UserEditModel *>*arr = self.models[indexPath.section];
    
    UserEditModel *model = arr[indexPath.row];
    
    cell.titleLbl.text = model.title;
    
    if (model.url || model.img) {
        
        [cell.userPhoto sd_setImageWithURL:[NSURL URLWithString:[model.url convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];

    } else {
        
        cell.contentLbl.text = model.content;
    }
    
    cell.lineView.hidden = indexPath.row == arr.count - 1? YES: NO;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseWeakSelf;
    
    NSArray <UserEditModel *>*arr = self.models[indexPath.section];
    
    UserEditModel *model = arr[indexPath.row];
    
    if (model.url) { //选择图片
        
        [self.imagePicker picker];
        
    } else { //其它编辑
        
        if (indexPath.section == 0) {
            
            switch (indexPath.row) {
                case 1: {//昵称
                    
                    EditVC *editVC = [[EditVC alloc] init];
                    editVC.title = @"填写昵称";
                    editVC.editModel = model;
                    editVC.type = UserEditTypeNickName;
                    [editVC setDone:^{
                        
                        [tableView reloadData];
                    }];
                    [self.navigationController pushViewController:editVC animated:YES];
                    
                }break;
                case 2: {//性别
                    
                    [TLAlert alertWithTitle:@"" msg:@"请选择您的性别" confirmMsg:@"女" cancleMsg:@"男" cancle:^(UIAlertAction *action) {
                        
                        model.content = @"男";
                        [weakSelf changeGender:model.content];
                        
                    } confirm:^(UIAlertAction *action) {
                        
                        model.content = @"女";
                        [weakSelf changeGender:model.content];
                    }];
                    
                }break;
                case 3: {//生日
                    
                    [self.datePicker show];
                    
                }break;
            }
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return indexPath.row == 0 ? 80 : 45;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return 10;
    }
    
    return 0.1;
}

@end
