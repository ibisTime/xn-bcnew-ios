//
//  EditVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/20.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "EditVC.h"
//Category
#import "UIBarButtonItem+convience.h"
#import "NSString+Check.h"
//V
#import "TLTextField.h"

@interface EditVC ()

@property (nonatomic, strong) TLTextField *contentTf;

@end

@implementation EditVC

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.contentTf becomeFirstResponder];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.contentTf resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [UIBarButtonItem addRightItemWithTitle:@"保存"
                                titleColor:kWhiteColor
                                     frame:CGRectMake(0, 0, 40, 40)
                                        vc:self
                                    action:@selector(hasDone)];
    
    if (!self.editModel) {
        NSLog(@"数据模型？？？？");
        return;
    }
    
    if (self.type == UserEditTypeEmail) {
        
        self.contentTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 45) leftTitle:@"邮箱" titleWidth:80 placeholder:@"请输入您的邮箱"];
        self.contentTf.keyboardType = UIKeyboardTypeEmailAddress;
        [self.view addSubview:self.contentTf];
        
    } else {
        
        self.contentTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 45) leftTitle:@"昵称" titleWidth:80 placeholder:@"请填写昵称"];
        [self.view addSubview:self.contentTf];
    }
    
}

- (void)hasDone {
    
    if (![self.contentTf.text valid]) {
        [TLAlert alertWithInfo:@"请输入昵称"];
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805084";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"nickname"] = self.contentTf.text;
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"修改成功"];
        [TLUser user].nickname = self.contentTf.text;
        
        [[TLUser user] updateUserInfo];
        self.editModel.content = self.contentTf.text;
        
        if (self.done) {
            self.done();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
        
    } failure:^(NSError *error) {
        
    }];
}

@end
