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

struct TitleInfo {
    NSInteger length;
    NSInteger number;
};

typedef struct TitleInfo TitleInfo;

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
    
    self.contentTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 45)
                                              leftTitle:@"昵称"
                                             titleWidth:80
                                            placeholder:@"请填写昵称"];
    
    self.contentTf.text = [[TLUser user].nickname valid] ? [TLUser user].nickname: @"";
    
    [self.contentTf addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingDidEnd];
    
    [self.view addSubview:self.contentTf];
    //提示
    UILabel *promptLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kThemeColor
                                                      font:14.0];
    
    promptLbl.frame = CGRectMake(15, self.contentTf.yy + 5, kScreenWidth - 30, 30);
    
    promptLbl.text = @"昵称不能超过8个汉字或16个英文字母";
    
    [self.view addSubview:promptLbl];
    
}

#pragma mark - Events
- (void)textDidChange:(UITextField *)sender {
    //允许输入的最大字符数
    NSInteger maxLength = 16;
    
    TitleInfo title = [self getInfoWithText:sender.text maxLength:maxLength];
    
    if (title.length > maxLength) {
        
        sender.text = [sender.text substringToIndex:title.number];
        
        [TLAlert alertWithInfo:@"昵称不能超过8个汉字或16个英文字母"];
    }
}

//判断中英混合的的字符串长度及字符个数
- (TitleInfo)getInfoWithText:(NSString *)text maxLength:(NSInteger)maxLength {
    
    TitleInfo title;
    int length = 0;
    int singleNum = 0;
    int totalNum = 0;
    char *p = (char *)[text cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            length++;
            if (length <= maxLength) {
                totalNum++;
            }
        }
        else {
            if (length <= maxLength) {
                singleNum++;
            }
        }
        p++;
    }
    
    title.length = length;
    title.number = (totalNum - singleNum) / 2 + singleNum;
    
    return title;
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
