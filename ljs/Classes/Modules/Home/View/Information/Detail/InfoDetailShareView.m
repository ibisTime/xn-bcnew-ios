//
//  InfoDetailShareView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "InfoDetailShareView.h"
//Category
#import "UIView+Responder.h"
#import "UIButton+EnLargeEdge.h"

#define kBgViewHeight  (150 + kBottomInsetHeight)

@interface InfoDetailShareView()

//
@property (nonatomic, assign) NSInteger count;
//
@property (nonatomic, assign) NSInteger secondCount;
//
@property (nonatomic, strong) UIButton *lastBtn;
//背景
@property (nonatomic, strong) UIView *bgView;
//第三方
@property (nonatomic, strong) NSMutableArray <ThirdLoginModel *>*thirdModels;

@end

@implementation InfoDetailShareView

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
    
    self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kBgViewHeight)];
    
    self.bgView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.bgView];
    //根据用户的安装情况添加分享源
    BOOL installedWeChat = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]];
    BOOL installedQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    BOOL installedWeibo = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]];
    BOOL installedWeibohd = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibohd://"]];
    
    NSMutableArray <ThirdLoginModel *>*arr = [NSMutableArray array];
    //判断是否安装QQ
    if (installedQQ) {
        
        ThirdLoginModel *qqModel = [self getThirdModelWithName:@"QQ" image:@"qq" type:ThirdTypeQQ];
        [arr addObject:qqModel];
    }
    
    //判断是否安装微信
    if (installedWeChat) {
        
        ThirdLoginModel *wechatModel = [self getThirdModelWithName:@"微信" image:@"wechat" type:ThirdTypeWeChat];
        [arr addObject:wechatModel];
        
        ThirdLoginModel *timeLineModel = [self getThirdModelWithName:@"朋友圈" image:@"timeline" type:ThirdTypeTimeLine];
        [arr addObject:timeLineModel];
    }
    //判断是否安装微博
//    if (installedWeibo || installedWeibohd) {
//
//        ThirdLoginModel *weiboModel = [self getThirdModelWithName:@"微博" image:@"weibo" type:ThirdTypeWeiBo];
//        [arr addObject:weiboModel];
//    }
//
    self.thirdModels = arr;
    
    __block CGFloat margin = kScreenWidth/(1.0*(arr.count+1));
    
    [arr enumerateObjectsUsingBlock:^(ThirdLoginModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat width = 100;
        
        UIButton *shareBtn = [UIButton buttonWithTitle:obj.name
                                            titleColor:kTextColor2
                                       backgroundColor:kClearColor
                                             titleFont:15.0];
        
        [shareBtn setImage:kImage(obj.photo) forState:UIControlStateNormal];
        
        shareBtn.contentMode = UIViewContentModeScaleAspectFit;
        shareBtn.tag = 1500 + obj.type;
        [shareBtn addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bgView addSubview:shareBtn];
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(@0);
            make.width.height.equalTo(@(width));
            make.left.equalTo(@((idx+1)*margin - width/2.0));
        }];
        
        [shareBtn setTitleBottom];
    }];
    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kHexColor(@"#eeeeee");
    
    [self.bgView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.top.equalTo(@100);
        make.height.equalTo(@1);
        
    }];
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithTitle:@"取消"
                                         titleColor:kTextColor2
                                    backgroundColor:kWhiteColor
                                          titleFont:16.0];
    
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.top.equalTo(topLine.mas_bottom);
        make.height.equalTo(@(50));
        make.width.equalTo(@(kScreenWidth));
    }];
}

- (ThirdLoginModel *)getThirdModelWithName:(NSString *)name image:(NSString *)image type:(ThirdType)type {
    
    ThirdLoginModel *model = [ThirdLoginModel new];
    
    model.name = name;
    model.photo = image;
    model.type = type;
    
    return model;
}

#pragma mark - Events
- (void)clickShare:(UIButton *)sender {
    
    NSInteger index = sender.tag - 1500;
    
    if (self.shareBlock) {
        
        self.shareBlock(index);
    }
    
    [self hide];

}

- (void)clickCancel {
    
    [self hide];
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 1;
        self.bgView.transform = CGAffineTransformMakeTranslation(0, -kBgViewHeight);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hide {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 0;
        self.bgView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self hide];
}

@end
