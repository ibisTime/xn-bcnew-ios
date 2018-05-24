//
//  CurrencyInfoCell2.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyInfoCell2.h"

@implementation CurrencyInfoCell2
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kLineColor;
    
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    //
    self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor3
                                                  font:12.0];
    
    [self.contentView addSubview:self.titleLbl];
    //
    self.contentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor3
                                                    font:12.0];
    self.contentLbl.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:self.contentLbl];
    //布局
    [self setSubviewLayout];
    
}

- (void)setSubviewLayout {
    
    //
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
        make.width.equalTo(@70);
    }];
    //
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLbl.mas_right).offset(10);
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
    }];
}

@end
