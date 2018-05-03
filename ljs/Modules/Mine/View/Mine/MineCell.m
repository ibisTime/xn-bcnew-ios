//
//  MineCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "MineCell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "UILabel+Extension.h"

@interface MineCell ()

@property (nonatomic, strong) UIImageView *iconIV;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIImageView *rightArrowIV;

@end

@implementation MineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    return self;
    
}

#pragma mark - Init
- (void)initSubviews {
    
    self.iconIV = [[UIImageView alloc] init];
    self.iconIV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.iconIV];
    
    //右边箭头
    self.rightArrowIV = [[UIImageView alloc] init];
    self.rightArrowIV.image = [UIImage imageNamed:@"更多-灰色"];
    [self.contentView addSubview:self.rightArrowIV];
    
    self.rightLabel = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:15.0];
    
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.rightLabel];
    
    //
    self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    [self.contentView addSubview:self.titleLbl];
    
    //
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kLineColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.width.equalTo(self.mas_width);
        make.height.mas_equalTo(@(kLineHeight));
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)setSubviewLayout {
    //小图标
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@16);
        make.height.equalTo(@16);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        
    }];
    //右箭头
    [self.rightArrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@7);
        make.height.equalTo(@12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        
    }];
    //右边text
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.lessThanOrEqualTo(@200);
        make.height.equalTo(@15.0);
        if (_mineModel.isHiddenArrow) {
            
            make.right.equalTo(self.mas_right).offset(-15);

        } else {
            
            make.right.equalTo(self.rightArrowIV.mas_left).offset(-15);
        }
        make.centerY.equalTo(@0);
        
    }];
    //左边text
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        if (_mineModel.isSpecial) {
            
            make.left.equalTo(self.iconIV.mas_left);
        } else {
            
            make.left.equalTo(self.iconIV.mas_right).offset(10);
        }
        
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

- (void)setMineModel:(MineModel *)mineModel {
    
    _mineModel = mineModel;
    
    self.iconIV.image = [UIImage imageNamed:mineModel.imgName];
    
    self.titleLbl.text = mineModel.text;

    self.rightLabel.text = mineModel.rightText;
    //布局
    [self setSubviewLayout];
    
    self.rightArrowIV.hidden = mineModel.isHiddenArrow;
}

@end
