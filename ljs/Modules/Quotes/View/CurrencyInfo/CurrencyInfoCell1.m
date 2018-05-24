//
//  CurrencyInfoCell1.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyInfoCell1.h"

@interface CurrencyInfoCell1()
//
@property (nonatomic, strong) UILabel *titleLbl1;
@property (nonatomic, strong) UILabel *titleLbl2;
@property (nonatomic, strong) UILabel *contentLbl1;
@property (nonatomic, strong) UILabel *contentLbl2;

@end

@implementation CurrencyInfoCell1

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
    self.titleLbl1 = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kTextColor3
                                                 font:12.0];
    
    [self.contentView addSubview:self.titleLbl1];
    //
    self.contentLbl1 = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor3
                                                    font:12.0];
    self.contentLbl1.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:self.contentLbl1];
    //
    self.titleLbl2 = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor3
                                                  font:12.0];
    
    [self.contentView addSubview:self.titleLbl2];
    //
    self.contentLbl2 = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor3
                                                  font:12.0];
    
    self.contentLbl2.textAlignment = NSTextAlignmentRight;

    [self.contentView addSubview:self.contentLbl2];
    //布局
    [self setSubviewLayout];
    
}

- (void)setSubviewLayout {
    
    CGFloat w = kScreenWidth/2.0;
    //
    [self.titleLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
        make.width.equalTo(@70);
    }];
    //
    [self.contentLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLbl1.mas_right).offset(10);
        make.right.equalTo(@(-(15+w)));
        make.centerY.equalTo(@0);
    }];
    //
    [self.titleLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15+w));
        make.centerY.equalTo(@0);
        make.width.equalTo(@70);
    }];
    //
    [self.contentLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLbl2.mas_right).offset(10);
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
    }];
}

#pragma mark - Setting

- (void)setTitleArr:(NSArray<NSString *> *)titleArr {
    
    _titleArr = titleArr;
    
    self.titleLbl1.text = titleArr[0];
    self.titleLbl2.text = titleArr[1];
}

- (void)setContentArr:(NSArray<NSString *> *)contentArr {
    
    _contentArr = contentArr;
    self.contentLbl1.text = contentArr[0];
    self.contentLbl2.text = contentArr[1];
}

@end
