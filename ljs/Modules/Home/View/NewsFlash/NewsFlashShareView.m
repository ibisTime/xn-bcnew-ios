//
//  NewsFlashShareView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/19.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "NewsFlashShareView.h"
//Category
#import "UIView+Responder.h"

@interface NewsFlashShareView()
//
@property (nonatomic, assign) NSInteger count;
//
@property (nonatomic, assign) NSInteger secondCount;
//
@property (nonatomic, strong) UIButton *lastBtn;

@end

@implementation NewsFlashShareView

static NSString *kShareTypeWeChat   = @"WeChat";
static NSString *kShareTypeTimeLine = @"TimeLine";
static NSString *kShareTypeQQ       = @"QQ";
static NSString *kShareTypeWeiBo    = @"WeiBo";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.backgroundColor = kWhiteColor;
    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kLineColor;
    
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithImageName:@"返回-灰色"];
    
    [backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(@0);
        make.width.height.equalTo(@(50));
    }];
    //根据用户的安装情况添加分享源
    BOOL installedWeChat = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]];
    BOOL installedQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    BOOL installedWeibo = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]];
    BOOL installedWeibohd = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibohd://"]];
    
    NSDictionary *dic = @{
                          kShareTypeWeChat: @"wechat_small",
                          kShareTypeTimeLine: @"timeline_small",
                          kShareTypeQQ: @"qq_small",
                          kShareTypeWeiBo: @"weibo_small",
                          };
//    //判断是否安装微博
//    if (installedWeibo || installedWeibohd) {
//
//        [self createBtnWithShareType:NewsFlashShareTypeWeiBo image:dic[kShareTypeWeiBo]];
//    }
    //判断是否安装微信
    if (installedWeChat) {
        
        [self createBtnWithShareType:NewsFlashShareTypeTimeLine image:dic[kShareTypeTimeLine]];
        
        [self createBtnWithShareType:NewsFlashShareTypeWeChat image:dic[kShareTypeWeChat]];
    }
    //判断是否安装QQ
    if (installedQQ) {
        
        [self createBtnWithShareType:NewsFlashShareTypeQQ image:dic[kShareTypeQQ]];
    }
    
}

- (void)createBtnWithShareType:(NewsFlashShareType)shareType image:(NSString *)image {
    
    UIButton *shareBtn = [UIButton buttonWithImageName:image];
    
    shareBtn.contentMode = UIViewContentModeScaleAspectFit;
    shareBtn.tag = 1500 + shareType;
    [shareBtn addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@40);
        if (self.lastBtn) {
            
            make.right.equalTo(self.lastBtn.mas_left).offset(-10);
        } else {
            
            make.right.equalTo(@(-10));
        }
    }];
    
    self.lastBtn = shareBtn;
}

#pragma mark - Events
- (void)clickShare:(UIButton *)sender {

    NSInteger type = sender.tag - 1500;
    
    if (self.shareBlock) {
        
        self.shareBlock(type);
    }
}

- (void)clickBack {
    
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

@end
