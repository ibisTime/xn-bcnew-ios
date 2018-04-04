//
//  TLUser.m
//  ljs
//
//  Created by  tianlei on 2016/12/14.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "TLUser.h"

#import "UserDefaultsUtil.h"
//#import "CurrencyModel.h"
#import "TLNetworking.h"
#import "APICodeMacro.h"
#import "TLUIHeader.h"
#import "AppConfig.h"
#import "NSString+Check.h"
//#import "TabbarViewController.h"

#define USER_ID_KEY @"user_id_key"
#define TOKEN_ID_KEY @"token_id_key"
#define USER_INFO_DICT_KEY @"user_info_dict_key"

NSString *const kUserLoginNotification = @"kUserLoginNotification";
NSString *const kUserLoginOutNotification = @"kUserLoginOutNotification";
NSString *const kUserInfoChange = @"kUserInfoChange";

@implementation TLUser

+ (instancetype)user {

    static TLUser *user = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        user = [[TLUser alloc] init];
        
    });
    
    return user;

}

#pragma mark - Setting

- (void)setToken:(NSString *)token {
    
    _token = [token copy];
    [[NSUserDefaults standardUserDefaults] setObject:_token forKey:TOKEN_ID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)setUserId:(NSString *)userId {
    
    _userId = [userId copy];
    [[NSUserDefaults standardUserDefaults] setObject:_userId forKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 登录状态才调用
- (void)loadUserInfoFromDB {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefault objectForKey:USER_ID_KEY];
    NSString *token = [userDefault objectForKey:TOKEN_ID_KEY];
    //
    self.userId = userId;
    self.token = token;
    //
    NSDictionary *dict = [userDefault objectForKey:USER_INFO_DICT_KEY];
    [self setUserInfoWithDict:dict];
    
}

- (BOOL)checkLogin {

    if ([self isLogin]) {
        
        [self loadUserInfoFromDB];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)isLogin {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefault objectForKey:USER_ID_KEY];
    NSString *token = [userDefault objectForKey:TOKEN_ID_KEY];
    if (userId && token) {
        
        self.userId = userId;
        self.token = token;
        [self setUserInfoWithDict:[userDefault objectForKey:USER_INFO_DICT_KEY]];
        
        return YES;
    }
    
    return NO;
}

- (void)requestQiniuDomain {
    
    TLNetworking *http = [TLNetworking new];
    http.code = USER_CKEY_CVALUE;
    http.parameters[SYS_KEY] = @"qiniu_domain";
    [http postWithSuccess:^(id responseObject) {
        
        [AppConfig config].qiniuDomain = [NSString stringWithFormat:@"http://%@", responseObject[@"data"][@"cvalue"]];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)loginOut {

    self.userId = @"";
    self.token = @"";
    self.photo = nil;
    self.mobile = nil;
    self.nickname = nil;
    self.realName = nil;
    self.gender = nil;
    self.birthday = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_INFO_DICT_KEY];
}

- (void)saveUserInfo:(NSDictionary *)userInfo {

    NSLog(@"原%@--现%@",[TLUser user].userId,userInfo[@"userId"]);
    
    if (![[TLUser user].userId isEqualToString:userInfo[@"userId"]]) {
        
        @throw [NSException exceptionWithName:@"用户信息错误" reason:@"后台原因" userInfo:nil];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:USER_INFO_DICT_KEY];
    //
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateUserInfo {

    TLNetworking *http = [TLNetworking new];
    
    http.isShowMsg = NO;
    http.code = USER_INFO;
    http.parameters[@"userId"] = self.userId;
    http.parameters[@"token"] = self.token;
    
    [http postWithSuccess:^(id responseObject) {
        
        [self setUserInfoWithDict:responseObject[@"data"]];
        [self saveUserInfo:responseObject[@"data"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];

    } failure:^(NSError *error) {
        
    }];
}

- (void)setUserInfoWithDict:(NSDictionary *)dict {
    
    self.mobile = dict[@"mobile"];
    self.nickname = dict[@"nickname"];
    self.realName = dict[@"realName"];
    self.photo = dict[@"photo"];
    self.gender = dict[@"gender"];
    self.birthday = dict[@"birthday"];
}

- (void)saveUserName:(NSString *)userName pwd:(NSString *)pwd {
    
    self.userName = userName;
    self.userPassward = pwd;
    
    [UserDefaultsUtil setUserDefaultName:userName];
    [UserDefaultsUtil setUserDefaultPassword:pwd];
}

@end
