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

@interface ForumDetailHeaderView()
//吧名
//关注量
//发帖量
//今日更贴数
//24h最高价格
//24h最低价格
//24h成交量

//币吧信息
@property (nonatomic, strong) UIView *infoView;
//吧名
@property (nonatomic, strong) UILabel *postBarNameLbl;
//关注量
@property (nonatomic, strong) UILabel *followNumLbl;
//发帖量
@property (nonatomic, strong) UILabel *postNumLbl;
//今日更贴数
@property (nonatomic, strong) UILabel *updatePostNumLbl;
//24h最高价格
@property (nonatomic, strong) UILabel *oneDayHighPriceLbl;
//24h最低价格
@property (nonatomic, strong) UILabel *oneDayLowPriceLbl;
//24h成交量
@property (nonatomic, strong) UILabel *oneDayVolumeLbl;

//描述


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
    self.oneDayHighPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                      textColor:kTextColor2
                                                           font:15.0];
    [self.infoView addSubview:self.oneDayHighPriceLbl];
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
        
        make.top.equalTo(self.postNumLbl.mas_bottom).offset(10);
        make.left.equalTo(self.postBarNameLbl.mas_left);
    }];
    //更贴数
    [self.updatePostNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.postNumLbl.mas_bottom).offset(10);
        make.left.equalTo(self.postBarNameLbl.mas_left);
    }];
    //最高(24h)
    [self.oneDayHighPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kScreenWidth/2.0+15));
        make.top.equalTo(self.followNumLbl.mas_top);
    }];
    //最低(24h)
    [self.oneDayLowPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.oneDayHighPriceLbl.mas_left);
        make.top.equalTo(self.postNumLbl.mas_top);
    }];
    //成交量
    [self.oneDayVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.oneDayHighPriceLbl.mas_left);
        make.top.equalTo(self.postNumLbl.mas_top);
    }];
}

@end
