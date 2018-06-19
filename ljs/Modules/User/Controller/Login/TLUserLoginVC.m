//
//  TLUserLoginVC.m
//  ljs
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "TLUserLoginVC.h"

//Macro
#import "APICodeMacro.h"
#import "AppMacro.h"
//Category
#import "NSString+Check.h"
#import "UIBarButtonItem+convience.h"
#import "UILabel+Extension.h"
#import "UIButton+EnLargeEdge.h"
//M
#import "ThirdLoginModel.h"
//V
#import "TLTextField.h"
#import "TLPickerTextField.h"
#import "CaptchaView.h"
#import "BaseView.h"

@interface TLUserLoginVC ()

@property (nonatomic, strong) TLTextField *phoneTf;
@property (nonatomic,strong) CaptchaView *captchaView;
//第三方登录
@property (nonatomic, strong) BaseView *thirdLoginView;
//手机号
@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, strong) UIImageView *bgImage;

@end

@implementation TLUserLoginVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //取消和注册
    [self setBarButtonItem];
    //
    [self setUpUI];
    //登录成功回调
    [self setUpNotification];
}

#pragma mark - Init

- (void)setBarButtonItem {

    //取消按钮
    UIButton *backBtn = [UIButton buttonWithImageName:kCancelIcon];
    
    backBtn.frame = CGRectMake(0, kStatusBarHeight, 80, 44);
    
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)setUpUI {
    
    self.view.backgroundColor = kWhiteColor;
    
    CGFloat margin = 32;
    CGFloat w = kScreenWidth - 2*margin;
    CGFloat h = ACCOUNT_HEIGHT;
    UIImageView *bgImage = [[UIImageView alloc] init];
    self.bgImage = bgImage;
    [self.view addSubview:bgImage];
//    bgImage.contentMode = UIViewContentModeScaleToFill;
    self.bgImage.image = kImage(@"登陆背景");

    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@5);
        make.right.equalTo(@-5);
        make.height.equalTo(@(kWidth(150)));
    }];
    UIView *bgView = [[UIView alloc] init];
    
    bgView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(kWidth(155)));
        make.left.equalTo(@(margin));
        make.height.equalTo(@(2*h+1));
        make.width.equalTo(@(w));
    }];
    
    //账号
    TLTextField *phoneTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, w, h)
                                                     leftTitle:@"+86  |"
                                                   titleWidth:70
                                                  placeholder:@"手机号码"];
    
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;

    [bgView addSubview:phoneTf];
    self.phoneTf = phoneTf;
    
    //验证码
    CaptchaView *captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(0, phoneTf.yy + 1, w, h)];
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:captchaView];
    
    self.captchaView = captchaView;
    
    for (int i = 0; i < 2; i++) {
        
        UIView *line = [[UIView alloc] init];
        
        line.backgroundColor = kLineColor;
        
        [bgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@0.5);
            make.top.equalTo(@((i+1)*h));
        }];
    }
    //登录
    UIButton *loginBtn = [UIButton buttonWithTitle:@"快速登录" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:17.0 cornerRadius:5];
    [loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.height.equalTo(@(h - 5));
        make.width.equalTo(@(kWidth(245)));
        make.top.equalTo(bgView.mas_bottom).offset(28);
    }];
    //第三方登录
//    [self initThirdLoginView];
    
}

/**
 第三方登录
 */
- (void)initThirdLoginView {
    
    self.thirdLoginView = [[BaseView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 160, kScreenWidth, 160)];
    
    [self.view addSubview:self.thirdLoginView];
    
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kHexColor(@"#E2E2E2");
    
    [self.thirdLoginView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@0.5);
        make.top.equalTo(@(15));
    }];
    //text
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kWhiteColor
                                               textColor:kHexColor(@"#737373")
                                                    font:15.0];
    textLbl.textAlignment = NSTextAlignmentCenter;
    textLbl.text = @"第三方登录";
    [self.thirdLoginView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.centerY.equalTo(line.mas_centerY);
        make.width.equalTo(@110);
    }];
    //根据用户的安装情况添加登录源
    BOOL installedWeChat = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]];
    BOOL installedQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    BOOL installedWeibo = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]];
    BOOL installedWeibohd = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibohd://"]];
    
    NSMutableArray <ThirdLoginModel *>*arr = [NSMutableArray array];
    //判断是否安装QQ
    if (installedQQ) {
        
        ThirdLoginModel *model = [self getThirdModelWithName:@"QQ登录" image:@"qq"];
        [arr addObject:model];
    }
    
    //判断是否安装微信
    if (installedWeChat) {
        
        ThirdLoginModel *model = [self getThirdModelWithName:@"微信登录" image:@"wechat"];
        [arr addObject:model];
    }
    //判断是否安装微博
    if (installedWeibo || installedWeibohd) {
        
        ThirdLoginModel *model = [self getThirdModelWithName:@"微博登录" image:@"weibo"];
        [arr addObject:model];
    }
    
    __block CGFloat margin = kScreenWidth/(1.0*(arr.count+1));

    [arr enumerateObjectsUsingBlock:^(ThirdLoginModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat width = 100;
        
        UIButton *shareBtn = [UIButton buttonWithTitle:obj.name
                                            titleColor:kTextColor2
                                       backgroundColor:kClearColor
                                             titleFont:15.0];
        
        [shareBtn setImage:kImage(obj.photo) forState:UIControlStateNormal];
        
        shareBtn.contentMode = UIViewContentModeScaleAspectFit;
        shareBtn.tag = 1500 + idx;
        [shareBtn addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.thirdLoginView addSubview:shareBtn];
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(@30);
            make.width.height.equalTo(@(width));
            make.left.equalTo(@((idx+1)*margin - width/2.0));
        }];
        
        [shareBtn setTitleBottom];
    }];
}

- (ThirdLoginModel *)getThirdModelWithName:(NSString *)name image:(NSString *)image {
    
    ThirdLoginModel *model = [ThirdLoginModel new];
    
    model.name = name;
    model.photo = image;
    
    return model;
}

- (void)setUpNotification {

    //登录成功之后，给予回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:kUserLoginNotification object:nil];
}

#pragma mark - Events

- (void)back {
    
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//登录成功
- (void)login {

    [self dismissViewControllerAnimated:YES completion:nil];

    if (self.loginSuccess) {

        self.loginSuccess();
    }
}

/**
 分享
 */
- (void)clickShare:(UIButton *)sender {
    
    NSInteger index = sender.tag - 1500;
    
    
}

/**
 发送验证码
 */
- (void)sendCaptcha {
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = CAPTCHA_CODE;
    http.parameters[@"bizType"] = USER_LOGIN_CODE;
    http.parameters[@"mobile"] = self.phoneTf.text;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"验证码已发送,请注意查收"];
        
        [self.captchaView.captchaBtn begin];
        
        [self.captchaView.captchaTf becomeFirstResponder];
        
    } failure:^(NSError *error) {
        
        [TLAlert alertWithError:@"发送失败,请检查手机号"];
        
    }];
}

/**
 登录
 */
- (void)goLogin {
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }
    
    if (!(self.captchaView.captchaTf.text && self.captchaView.captchaTf.text.length > 3)) {
        [TLAlert alertWithInfo:@"请输入正确的验证码"];
        
        return;
    }
    
    [self.view endEditing:YES];

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_LOGIN_CODE;
    
    http.parameters[@"mobile"] = self.phoneTf.text;
    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
    http.parameters[@"kind"] = APP_KIND;

    [http postWithSuccess:^(id responseObject) {
        
        [self requesUserInfoWithResponseObject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requesUserInfoWithResponseObject:(id)responseObject {
    
    NSString *token = responseObject[@"data"][@"token"];
    NSString *userId = responseObject[@"data"][@"userId"];
    
    //1.获取用户信息
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_INFO;
    http.parameters[@"userId"] = userId;
    http.parameters[@"token"] = token;
    [http postWithSuccess:^(id responseObject) {
        
        NSDictionary *userInfo = responseObject[@"data"];
        
        [TLUser user].userId = userId;
        [TLUser user].token = token;
        
        //保存用户信息
        [[TLUser user] saveUserInfo:userInfo];
        [MobClick profileSignInWithPUID:[TLUser user].userId];

        //初始化用户信息
        [[TLUser user] setUserInfoWithDict:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
        
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark - 推送
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    
    NSLog(@"TagsAlias回调:%@", callbackString);
}

- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


/**
 VC被释放时移除通知
 */
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
