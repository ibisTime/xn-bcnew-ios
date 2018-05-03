//
//  ForumDetailHeaderView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumDetailHeaderView.h"

//Macro
#import "AppColorMacro.h"
#import "TLUIHeader.h"
//Category
#import "UIButton+EnLargeEdge.h"
#import "UILabel+Extension.h"
#import "NSString+Extension.h"
#import "NSString+Check.h"

@interface ForumDetailHeaderView()
//币吧信息
@property (nonatomic, strong) UIView *infoView;
//吧名
@property (nonatomic, strong) UILabel *postBarNameLbl;
//关注量
@property (nonatomic, strong) UILabel *followNumLbl;
//发帖量
@property (nonatomic, strong) UILabel *postNumLbl;
//今日跟贴数
@property (nonatomic, strong) UILabel *updatePostNumLbl;
//24h涨跌幅度
@property (nonatomic, strong) UILabel *oneDayChangeRateLbl;
//24h最低价格
@property (nonatomic, strong) UILabel *oneDayLowPriceLbl;
//24h成交量
@property (nonatomic, strong) UILabel *oneDayVolumeLbl;
//描述
@property (nonatomic, strong) UILabel *descLbl;
//展开/收起
@property (nonatomic, strong) UIButton *showBtn;

@end

@implementation ForumDetailHeaderView

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
    
    //
    self.infoView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self addSubview:self.infoView];
    //吧名
    self.postBarNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor
                                                       font:17.0];
    [self.infoView addSubview:self.postBarNameLbl];
    //关注量
    self.followNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor2
                                                     font:15.0];
    [self.infoView addSubview:self.followNumLbl];
    //发帖量
    self.postNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor2
                                                   font:15.0];
    [self.infoView addSubview:self.postNumLbl];
    //更贴数
    self.updatePostNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kTextColor2
                                                         font:15.0];
    [self.infoView addSubview:self.updatePostNumLbl];
    //最高(24h)
    self.oneDayChangeRateLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                      textColor:kTextColor2
                                                           font:15.0];
    [self.infoView addSubview:self.oneDayChangeRateLbl];
    //最低(24h)
    self.oneDayLowPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                      textColor:kTextColor2
                                                           font:15.0];
    [self.infoView addSubview:self.oneDayLowPriceLbl];
    //成交量
    self.oneDayVolumeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                      textColor:kTextColor2
                                                           font:15.0];
    [self.infoView addSubview:self.oneDayVolumeLbl];
    //描述
    self.descLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor
                                                font:17.0];
    
    self.descLbl.numberOfLines = 5;
    [self addSubview:self.descLbl];
    //展开按钮
    self.showBtn = [UIButton buttonWithTitle:@"展开" titleColor:kTextColor2 backgroundColor:kClearColor titleFont:13.0];
    
    [self.showBtn setTitle:@"收起" forState:UIControlStateSelected];
    
    [self.showBtn addTarget:self action:@selector(showTitleContent:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.showBtn setEnlargeEdge:20];
    
    [self addSubview:self.showBtn];
}

- (void)setSubviewLayout {
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@140);
    }];
    //吧名
    [self.postBarNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@15);
    }];
    //关注量
    [self.followNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.postBarNameLbl.mas_left);
        make.top.equalTo(self.postBarNameLbl.mas_bottom).offset(10);
    }];
    //发帖量
    [self.postNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.followNumLbl.mas_bottom).offset(10);
        make.left.equalTo(self.postBarNameLbl.mas_left);
    }];
    //更贴数
    [self.updatePostNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.postNumLbl.mas_bottom).offset(10);
        make.left.equalTo(self.postBarNameLbl.mas_left);
    }];
    //24h涨跌幅度
    [self.oneDayChangeRateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kScreenWidth/2.0+15));
        make.top.equalTo(self.followNumLbl.mas_top);
    }];
//    //最低(24h)
//    [self.oneDayLowPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.oneDayChangeRateLbl.mas_left);
//        make.top.equalTo(self.postBarNameLbl.mas_top);
//    }];
    //成交量
    [self.oneDayVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.oneDayChangeRateLbl.mas_left);
        make.top.equalTo(self.postNumLbl.mas_top);
    }];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kHexColor(@"#E2E2E2");
    
    [self.infoView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@0);
    }];
    //内容
    [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.width.equalTo(@(kScreenWidth - 20));
        make.top.equalTo(self.infoView.mas_bottom).offset(15);
    }];
    //展开按钮
    [self.showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.descLbl.mas_bottom).offset(0);
        make.centerX.equalTo(@0);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
}

#pragma mark - Events
- (void)showTitleContent:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        _descLbl.numberOfLines = 0;
        
        [_descLbl labelWithTextString:_detailModel.introduce lineSpace:5];
        
    } else {
        
        _descLbl.numberOfLines = 5;
        
        [_descLbl labelWithTextString:_detailModel.introduce lineSpace:5];
    }
    //刷新布局
    [self layoutIfNeeded];
    
    self.height = self.showBtn.yy + 20;
    //刷新headerView
    if (self.refreshHeaderBlock) {
        
        self.refreshHeaderBlock();
    }
}

#pragma mark - Setting
- (void)setDetailModel:(ForumDetailModel *)detailModel {
    
    _detailModel = detailModel;
    //吧名
    self.postBarNameLbl.text = [NSString stringWithFormat:@"#%@#", detailModel.name];
    //关注量
    NSString *keepCount = [NSString stringWithFormat:@"%ld", detailModel.keepCount];
    
    self.followNumLbl.text = [NSString stringWithFormat:@"关注量:%@", [keepCount convertLargeNumberWithNum:2]];
    //发帖量
    NSString *postCount = [NSString stringWithFormat:@"%ld", detailModel.postCount];
    self.postNumLbl.text = [NSString stringWithFormat:@"发帖量:%@", [postCount convertLargeNumberWithNum:2]];
    //今日跟贴数
    NSString *dayCommentCount = [NSString stringWithFormat:@"%ld", detailModel.dayCommentCount];
    
    NSString *updatePost = [NSString stringWithFormat:@"今日跟贴:%@", [dayCommentCount convertLargeNumberWithNum:2]];
    [self.updatePostNumLbl labelWithString:updatePost
                                     title:[dayCommentCount convertLargeNumberWithNum:2]
                                      font:Font(15.0)
                                     color:kThemeColor];
    //24h涨跌幅度
    if ([detailModel.coin.todayChange valid]) {
        
        self.oneDayChangeRateLbl.text = [NSString stringWithFormat:@"涨跌幅:%@%%", detailModel.coin.todayChange];
    }
    //24h成交量
    if ([detailModel.coin.todayVol valid]) {
        
        self.oneDayVolumeLbl.text = [NSString stringWithFormat:@"成交(24h):%@", [detailModel.coin.todayVol convertLargeNumberWithNum:2]];
    }
    
    //描述
    self.descLbl.text = detailModel.introduce;
    //布局
    [self setSubviewLayout];
    //
    [self layoutIfNeeded];
    
    //计算内容行数
    NSInteger count = [self.descLbl getLinesArrayOfStringInLabel];
    self.showBtn.hidden = count > 5 ? NO: YES;
    
    self.height = count > 5 ? self.showBtn.yy + 20: self.descLbl.yy + 20;
}

@end
