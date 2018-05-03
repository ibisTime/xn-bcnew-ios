//
//  LinkLabel.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/7.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "LinkLabel.h"
#import "TLAlert.h"

@interface LinkLabel ()<MLLinkLabelDelegate>

@end

@implementation LinkLabel

//代理，处理点击事件
- (void)didClickLink:(MLLink*)link linkText:(NSString*)linkText linkLabel:(MLLinkLabel*)linkLabel {
    
    
    switch (link.linkType) {
        case MLLinkTypeURL: { //连接
//            
//            CSWWebVC *webVC = [[CSWWebVC alloc] init];
//            webVC.url = link.linkValue;
//            [[self nextNavController] pushViewController:webVC animated:YES];
            
        }break;
        case MLLinkTypePhoneNumber: { //电话
            
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",link.linkValue];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
        }break;
        case MLLinkTypeEmail: { //连接
            
            [TLAlert alertWithInfo:@"亲，这是一个邮箱"];
            
        }break;
            
        case MLLinkTypeUserHandle: { //用户
            
            //此处只能查找出用户昵称
            //根据昵称，查找出该用户
//            CSWUserDetailVC *detailVC = [[CSWUserDetailVC alloc] init];
//            detailVC.nickName = [link.linkValue substringFromIndex:1];
//            [[self nextNavController] pushViewController:detailVC animated:YES];
            
        }break;
            
        default: {//应该是用户的ID
            
            //目前也应该只有用户
//            CSWUserDetailVC *detailVC = [[CSWUserDetailVC alloc] init];
//            detailVC.nickName = link.linkValue;
//            [[self nextNavController] pushViewController:detailVC animated:YES];
            
        }
            
    }
    
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initAction];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initAction];
        
    }
    return self;
}

- (void)initAction {
    
    self.lineHeightMultiple = 1.2f;
    self.dataDetectorTypes = MLDataDetectorTypeAll;
    self.delegate = self;
    
}

@end
