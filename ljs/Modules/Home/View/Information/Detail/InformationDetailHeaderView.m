//
//  InformationDetailHeaderView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/20.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "InformationDetailHeaderView.h"

//Macro
#import "TLNetworking.h"
#import "TLUser.h"
#import "TLAlert.h"
//Category
#import "UILabel+Extension.h"
#import "NSString+Date.h"
#import "UIView+Responder.h"
#import "NSString+Check.h"
//Extension
//M
//V
#import "DetailWebView.h"
//C
#import "BaseViewController.h"

@interface InformationDetailHeaderView()
@property (nonatomic, strong)UILabel *AbstractLbl;
//标题
@property (nonatomic, strong) UILabel *titleLbl;
//富文本
@property (nonatomic, strong) DetailWebView *detailView;
//来源
@property (nonatomic, strong) BaseView *sourceView;
//作者
@property (nonatomic, strong) UILabel *authorLbl;
@property (nonatomic, strong) UILabel *sourceLbl;
//时间
@property (nonatomic, strong) UILabel *timeLbl;
//点赞
@property (nonatomic, strong) UIButton *zanBtn;
//点赞数
@property (nonatomic, strong) UILabel *zanNumLbl;
//分享
@property (nonatomic, strong) BaseView *shareView;

@property (nonatomic, strong) UIButton *seeNumber;
@property (nonatomic, strong) UILabel *theLabel;
@end

@implementation InformationDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
        //来源
        [self initSourceView];
        //分享
        [self initShareView];
    }
    return self;
}

#pragma mark - Init
- (DetailWebView *)detailView {
    
    if (!_detailView) {
        
        BaseWeakSelf;
        
        _detailView = [[DetailWebView alloc] initWithFrame:CGRectMake(0, self.AbstractLbl.yy + 20, kScreenWidth, 50)];
        
        _detailView.webViewBlock = ^(CGFloat height) {
            
            [weakSelf setSubViewLayoutWithHeight:height];
        };
    }
    return _detailView;
}

- (void)initSubviews {
    //标题
    self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kHexColor(@"#3A3A3A")
                                                 font:20.0];
    self.titleLbl.numberOfLines = 0;
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.titleLbl];
    //来源
    [self initSourceView];
    [self addSubview:self.detailView];
    //点赞
    self.zanBtn = [UIButton buttonWithImageName:@"圆未点赞"];
    
    [self.zanBtn addTarget:self action:@selector(clickZan:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.zanBtn];
    //点赞数
    self.zanNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor
                                                  font:17.0];
    
    [self addSubview:self.zanNumLbl];
}

- (void)initSourceView {
    
    //来源
    self.sourceView = [[BaseView alloc] initWithFrame:CGRectZero];
    
    self.sourceView.backgroundColor = kHexColor(@"#F7F7F7");
    
    [self addSubview:self.sourceView];
    //作者
    self.authorLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor2
                                                  font:15.0];
    
    [self.sourceView addSubview:self.authorLbl];
    [self.authorLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@10);
        make.top.equalTo(@13);
    }];
    //来源
    self.sourceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor2
                                                  font:15.0];
    
    [self.sourceView addSubview:self.sourceLbl];
    [self.sourceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.authorLbl.mas_left);
        make.top.equalTo(self.authorLbl.mas_bottom).offset(10);
    }];
    self.seeNumber = [UIButton buttonWithTitle:@"0"
                                    titleColor:kTextColor2
                               backgroundColor:kClearColor
                                     titleFont:13.0];
    [self.seeNumber setImage:[UIImage imageNamed:@"已报名浏览"] forState:UIControlStateNormal];
    [self.sourceView addSubview:self.seeNumber];
    [self.seeNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@-10);
        make.top.equalTo(self.sourceLbl.mas_top).offset(0);
        make.height.equalTo(@20);
    }];
    //时间
    self.timeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor2
                                                font:15.0];
    
    [self.sourceView addSubview:self.timeLbl];
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-10));
        make.top.equalTo(self.authorLbl.mas_top);
    }];
    
//    _theLabel = [UILabel labelWithFrame:CGRectZero textAligment:(NSTextAlignmentCenter) backgroundColor:kHexColor(@"#EF5959") font:FONT(11) textColor:kWhiteColor];
//    _theLabel.text = @"摘要";
////    _theLabel = theLabel;
//    kViewRadius(_theLabel, 2);
//    [self addSubview:_theLabel];
//
//
//
//    _AbstractLbl = [UILabel labelWithFrame:CGRectZero textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(16) textColor:kHexColor(@"3A3A3A")];
//    _AbstractLbl.numberOfLines = 0;
//    [self addSubview:_AbstractLbl];
//
//
//
//    [_AbstractLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(15);
//        make.top.equalTo(self.sourceView.mas_bottom).mas_equalTo(17);
//        make.right.mas_equalTo(-15);
//    }];
    
}

- (void)initShareView {
    
    self.shareView = [[BaseView alloc] initWithFrame:CGRectZero];
    
    [self addSubview:self.shareView];
    //朋友圈
//    UIButton *timelineBtn = [UIButton buttonWithTitle:@"朋友圈"
//                                           titleColor:kTextColor
//                                      backgroundColor:kClearColor
//                                            titleFont:17.0];
//
//    [timelineBtn addTarget:self action:@selector(shareToTimeLine) forControlEvents:UIControlEventTouchUpInside];
//    [timelineBtn setImage:kImage(@"timeline_small") forState:UIControlStateNormal];
//
//    [self.shareView addSubview:timelineBtn];
//    [timelineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.width.equalTo(@100);
//        make.height.equalTo(@40);
//        make.top.equalTo(@0);
//        make.right.equalTo(@(-15));
//    }];
//
//    [timelineBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
//
//    //微信好友
//    UIButton *wechatBtn = [UIButton buttonWithTitle:@"微信"
//                                         titleColor:kTextColor
//                                    backgroundColor:kClearColor
//                                          titleFont:17.0];
//
//    [wechatBtn addTarget:self action:@selector(shareToWechat) forControlEvents:UIControlEventTouchUpInside];
//    [wechatBtn setImage:kImage(@"wechat_small") forState:UIControlStateNormal];
//
//    [self.shareView addSubview:wechatBtn];
//    [wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.width.equalTo(@100);
//        make.height.equalTo(@40);
//        make.top.equalTo(@0);
//        make.right.equalTo(timelineBtn.mas_left).offset(-10);
//    }];
//
//    [wechatBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    
//    //text
//    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
//                                               textColor:kTextColor
//                                                    font:17.0];
//    textLbl.text = @"分享至";
//    [self.shareView addSubview:textLbl];
//    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(@15);
//        make.centerY.equalTo(wechatBtn.mas_centerY);
//    }];
//
//    //判断用户是否安装微信
//    BOOL installedWechat = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]];
//
//    self.shareView.hidden = !installedWechat;
//
//    //bottomLine
//    UIView *bottomLine = [[UIView alloc] init];
//
//    bottomLine.backgroundColor = kBackgroundColor;
//
//    [self addSubview:bottomLine];
//    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.right.equalTo(@0);
//        make.height.equalTo(@10);
//        make.top.equalTo(self.shareView.mas_bottom);
//    }];
}

/**
 调整视图高度
 */
- (void)setSubViewLayoutWithHeight:(CGFloat)height {
    
    //标题
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@22);
        make.top.equalTo(@20);
        make.width.equalTo(@(kScreenWidth - 44));
    }];
    //来源
    [self.sourceView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@10);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(20);
        make.width.equalTo(@(kScreenWidth - 20));
        make.height.equalTo(@70);
    }];
    
//    [_theLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(15);
//        make.top.equalTo(self.sourceView.mas_bottom).mas_equalTo(17);
//        make.width.mas_equalTo(32);
//        make.height.mas_equalTo(19);
//    }];
    
    //内容
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@2);
        make.width.equalTo(@(kScreenWidth - 4));
        make.top.equalTo(self.sourceView.mas_bottom).offset(20);
        make.height.equalTo(@(height));
    }];
    //点赞
    [self.zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(self.detailView.mas_bottom).offset(55);
        make.width.height.equalTo(@45);
    }];
    //点赞数
    [self.zanNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(self.zanBtn.mas_bottom).offset(5);
    }];
    //分享
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(@0);
        make.top.equalTo(self.zanNumLbl.mas_bottom).offset(50);
        make.height.equalTo(@40);
        make.width.equalTo(@(kScreenWidth));
    }];
//
    //
    [self layoutIfNeeded];
    
    self.height = self.shareView.yy + 10;
    self.contentSize = CGSizeMake(kScreenWidth, self.height);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HeaderViewDidLayout" object:nil];

}

#pragma mark - Events
- (void)shareToWechat {
    
    if (self.shareBlock) {
        
        self.shareBlock(InfoShareTypeWechat);
    }
}

- (void)shareToTimeLine {
    
    if (self.shareBlock) {
        
        self.shareBlock(InfoShareTypeTimeline);
    }
}

- (void)clickZan:(UIButton *)sender {
    
    BaseWeakSelf;
    
    BaseViewController *vc = (BaseViewController *)self.viewController;
    
    [vc checkLogin:^{
        
        [weakSelf pointInfo];
    }];
    
}

/**
 对资讯点赞
 */
- (void)pointInfo {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628201";
    http.showView = self;
    http.parameters[@"type"] = @"1";
    http.parameters[@"objectCode"] = self.detailModel.code;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *promptStr = [self.detailModel.isPoint isEqualToString:@"1"] ? @"取消点赞成功": @"点赞成功";
        [TLAlert alertWithSucces:promptStr];
        
        if ([self.detailModel.isPoint isEqualToString:@"1"]) {
            
            self.detailModel.isPoint = @"0";
            self.detailModel.pointCount -= 1;
            
        } else {
            
            self.detailModel.isPoint = @"1";
            self.detailModel.pointCount += 1;
        }
        
        NSString *image = [self.detailModel.isPoint isEqualToString:@"1"] ? @"圆点赞": @"圆未点赞";
        [self.zanBtn setImage:kImage(image) forState:UIControlStateNormal];
        self.zanNumLbl.text = [NSString stringWithFormat:@"%ld", self.detailModel.pointCount];
        UIColor *textColor = [self.detailModel.isPoint isEqualToString:@"0"] ? kTextColor: kHexColor(@"#FF4747");

        self.zanNumLbl.textColor = textColor;
        
    } failure:^(NSError *error) {
        
    }];
}


- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL)
    {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    
    return NO;
}

#pragma mark - Setting
- (void)setDetailModel:(InfoDetailModel *)detailModel {
    
    _detailModel = detailModel;
    
    [self.titleLbl labelWithTextString:detailModel.title lineSpace:5];
    NSString *auther = [detailModel.auther valid] ? detailModel.auther: @"- -";
    self.authorLbl.text = [NSString stringWithFormat:@"作者: %@", auther];
    self.sourceLbl.text = [NSString stringWithFormat:@"来自: %@", detailModel.source];
    [self.seeNumber setTitle:detailModel.readCount forState:UIControlStateNormal];
    self.timeLbl.text = [detailModel.showDatetime convertToDetailDate];
    NSString *image = [detailModel.isPoint isEqualToString:@"0"] ? @"圆未点赞": @"圆点赞";
    [self.zanBtn setImage:kImage(image) forState:UIControlStateNormal];
    if ([self isBlankString:detailModel.content] == NO) {
        [self.detailView loadWebWithString:detailModel.content];
    }
    UIColor *textColor = [detailModel.isPoint isEqualToString:@"0"] ? kTextColor: kHexColor(@"#FF4747");
    self.zanNumLbl.text = [NSString stringWithFormat:@"%ld", detailModel.pointCount];
    self.zanNumLbl.textColor = textColor;
//    if (detailModel.summary) {
//        _theLabel.hidden = NO;
//        _AbstractLbl.text = [NSString stringWithFormat:@"         %@",detailModel.summary];
//    }else
//    {
//        _theLabel.hidden = YES;
//    }
    
}

@end
