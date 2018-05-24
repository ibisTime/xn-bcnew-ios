//
//  CurrencyInfoHeaderView.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyInfoHeaderView.h"

//Category
#import "UIButton+EnLargeEdge.h"
#import "UILabel+Extension.h"
#import "NSString+Extension.h"
#import "NSString+Check.h"

@interface CurrencyInfoHeaderView()
//简介
@property (nonatomic, strong) UILabel *introduceLbl;
//展开/收起
@property (nonatomic, strong) UIButton *showBtn;

@end

@implementation CurrencyInfoHeaderView

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
    
    UIView *greyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    greyView.backgroundColor = kHexColor(@"#f5f5f9");
    
    [self addSubview:greyView];
    //简介
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kTextColor3
                                                         font:12.0];
    textLbl.text = @"项目简介";
    
    [greyView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        make.left.equalTo(@15);
    }];
    //
    self.introduceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor
                                                     font:13.0];
    self.introduceLbl.numberOfLines = 5;
    [self addSubview:self.introduceLbl];
    //展开按钮
    self.showBtn = [UIButton buttonWithTitle:@"展开" titleColor:kTextColor2 backgroundColor:kClearColor titleFont:13.0];
    
    [self.showBtn setTitle:@"收起" forState:UIControlStateSelected];
    
    [self.showBtn addTarget:self action:@selector(showTitleContent:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.showBtn setEnlargeEdge:20];
    
    [self addSubview:self.showBtn];
    
}

- (void)setSubviewLayout {
    
    //内容
    [self.introduceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.width.equalTo(@(kScreenWidth - 20));
        make.top.equalTo(@45);
    }];
    //展开按钮
    [self.showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.introduceLbl.mas_bottom).offset(0);
        make.centerX.equalTo(@0);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
}

#pragma mark - Events
- (void)showTitleContent:(UIButton *)sender {
    
    sender.selected = !sender.selected;

    _introduceLbl.numberOfLines = sender.selected ? 0: 5;

    [_introduceLbl labelWithTextString:_platform.coin.introduce lineSpace:5];

    //刷新布局
    [self layoutIfNeeded];
    
    self.height = self.showBtn.yy + 20;
    //刷新headerView
    if (self.refreshHeaderBlock) {
        
        self.refreshHeaderBlock();
    }
    
}

#pragma mark - Setting
- (void)setPlatform:(PlatformModel *)platform {
    
    _platform = platform;
    //简介
    self.introduceLbl.text = [platform.coin.introduce vaildString];
    //布局
    [self setSubviewLayout];
    //
    [self layoutIfNeeded];
    
    //计算内容行数
    NSInteger count = [self.introduceLbl getLinesArrayOfStringInLabel];
    self.showBtn.hidden = count > 5 ? NO: YES;
    
    self.height = count > 5 ? self.showBtn.yy + 20: self.introduceLbl.yy + 15;
}

@end
