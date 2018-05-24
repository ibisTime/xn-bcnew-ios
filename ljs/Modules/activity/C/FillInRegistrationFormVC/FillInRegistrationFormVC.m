//
//  FillInRegistrationFormVC.m
//  ljs
//
//  Created by apple on 2018/5/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "FillInRegistrationFormVC.h"
#import <Masonry.h>
#import "EditVC.h"
#import "TLTextField.h"
#import "NSString+Check.h"

struct TitleInfo {
    NSInteger length;
    NSInteger number;
};

typedef struct TitleInfo TitleInfo;

@interface FillInRegistrationFormVC ()<UITextFieldDelegate>
@property (nonatomic , strong) UILabel *lable;
@property (nonatomic , strong) UILabel *Phonelabel;
@property (nonatomic, strong) TLTextField *nameTf;
@property (nonatomic , strong) TLTextField *PhoneTf;





@end

@implementation FillInRegistrationFormVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写报名表";

    [self initRightBarBut];
    
    [self initSignInfomation];
    

    
    
}
- (void)initSignInfomation
{
    self.nameTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 45)
                                              leftTitle:@"真实姓名"
                                             titleWidth:100
                                            placeholder:@"请填写真实姓名"];
    [self.nameTf addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingDidEnd];
    self.nameTf.returnKeyType = UIReturnKeyNext;
    self.nameTf.tag = 20001;
    self.nameTf.delegate =self;

    
    [self.view addSubview:self.nameTf];
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 65, 375, 1);
    [self.view addSubview:view];
    self.PhoneTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 65, kScreenWidth, 45)
                                           leftTitle:@"手机号"
                                          titleWidth:100
                                         placeholder:@"请填写手机号"];
    self.PhoneTf.returnKeyType = UIReturnKeyDone;
    self.PhoneTf.keyboardType = UIKeyboardTypeNumberPad;
    self.PhoneTf.delegate =self;
    self.PhoneTf.tag = 20002;

    [self.PhoneTf addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingDidEnd];
    
    [self.view addSubview:self.PhoneTf];

}

#pragma mark - Events
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 20001) {
        self.nameTf.text = textField.text;
        
    }else
    {
        //是否校验手机号 待定
        self.PhoneTf.text = textField.text;

        }
    
    NSLog(@"%@",textField.text);
    
}

- (void)textDidChange:(UITextField *)sender {
    
    
    
}



////搜索输入框
//self.searchTF = [[TLTextField alloc] initWithFrame:CGRectZero
//                                         leftTitle:@""
//                                        titleWidth:0
//                                       placeholder:@"请输入平台/币种"];
//self.searchTF.delegate = self;
//self.searchTF.returnKeyType = UIReturnKeySearch;
//
//[self.searchTF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
//[searchBgView addSubview:self.searchTF];
//[self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
//
//    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 13, 0, 0));
//
//    make.width.mas_greaterThanOrEqualTo(kScreenWidth - 20 - 40 -  15 - 13);
//}];
//
-(void)initRightBarBut
{
    UIBarButtonItem * rightBar= [[UIBarButtonItem alloc]initWithTitle:@"报名" style:UIBarButtonItemStyleDone target:self action:@selector(signUpBegin)];
    rightBar.tintColor = kWhiteColor;
    self.navigationItem.rightBarButtonItem= rightBar;
}


-(void)signUpBegin
{
    if (self.nameTf.text.length>0 && self.PhoneTf.text.length>0) {
        NSLog(@"报名");
        BOOL is = [self.PhoneTf.text isPhoneNum];
        if (is == NO) {
            [TLAlert alertWithInfo:@"请输入正确的手机号"];
            return;
        }

        [self startSignUp];
    }
}
- (void)startSignUp
{
    [self checkLogin:^{
        
    }];
    if (![TLUser user].userId) {
        return;
    }
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"628520";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"code"] = self.code;
    http.parameters[@"realName"] = self.nameTf.text;
    http.parameters[@"mobile"] = self.PhoneTf.text;
    [http postWithSuccess:^(id responseObject) {
        
        
        [self.view endEditing:YES];
        
        [TLAlert alertWithSucces:@"报名成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SignSucess" object:nil];
        
    } failure:^(NSError *error) {
        [TLAlert alertWithSucces:@"报名失败"];

        [self.view endEditing:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SignSucess" object:nil];



    }];

    [self.navigationController popoverPresentationController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.code = nil;
    
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
