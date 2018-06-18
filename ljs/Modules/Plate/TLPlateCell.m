//
//  TLPlateCell.m
//  ljs
//
//  Created by shaojianfei on 2018/6/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLPlateCell.h"
#import "UILabel+Extension.h"
#import "UILable+convience.h"
#import "AppColorMacro.h"
#import <Masonry.h>
@interface TLPlateCell()

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *contentLab;

@property (nonatomic, strong) UILabel *nameLab;

@property (nonatomic, strong) UILabel *nameprice;



@end
@implementation TLPlateCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self initLayout];
    }
    return self;

}
- (void)initSubviews
{
    self.titleLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];
    [self addSubview:self.titleLab];
    
    self.contentLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16.0];
    [self addSubview:self.contentLab];
    
    self.nameLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    [self addSubview:self.nameLab];
    
    self.nameprice = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:12.0];
    [self addSubview:self.nameprice];
    
    
    
}
- (void)initLayout
{
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(@5);
    }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.mas_left);
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLab.mas_left);
        make.top.equalTo(self.contentLab.mas_bottom).offset(5);
    }];
    [self.nameprice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_right).offset(5);
        make.top.equalTo(self.contentLab.mas_bottom).offset(5);
    }];
}

-(void)setModel:(PlateMineModel *)model
{
 
    _model = model;
    self.titleLab.text = model.name;
    CGFloat f =  [model.avgChange floatValue]*100;
    if (f > 0) {
        self.contentLab.text = [NSString stringWithFormat:@"+%.2f%%",[model.avgChange doubleValue]*100];
        
        self.contentLab.textColor = kRiseColor;
    }else
    {
        self.contentLab.text = [NSString stringWithFormat:@"%.2f%%",[model.avgChange doubleValue]*100];
        self.contentLab.textColor = kbottomColor;

    }
    self.nameLab.text = model.bestSymbol;
    CGFloat pricef = [model.bestChange floatValue]*100;
    if (pricef > 0) {
        self.nameprice.text = [NSString stringWithFormat:@"+%.2f%%",[model.bestChange floatValue]*100];

        self.nameprice.textColor = kRiseColor;

    }else
    {
        self.nameprice.text = [NSString stringWithFormat:@"%.2f%%",[model.bestChange floatValue]*100];
        self.nameprice.textColor = kbottomColor;

        }
    
}
@end
