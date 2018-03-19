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

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIImageView *accessoryImageView;

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
    
    self.iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImageView];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        
    }];
    
    //右边箭头
    self.accessoryImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.accessoryImageView];
    [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@7);
        make.height.equalTo(@12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        
    }];
    self.accessoryImageView.image = [UIImage imageNamed:@"更多-灰色"];
    
    self.rightLabel = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:15.0];
    
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.lessThanOrEqualTo(@200);
        make.height.equalTo(@15.0);
        make.right.equalTo(self.accessoryImageView.mas_left).offset(-15);
        make.centerY.equalTo(@0);
        
    }];
    
    //
    self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    [self.contentView addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
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

- (void)setMineModel:(MineModel *)mineModel {
    
    self.iconImageView.image = [UIImage imageNamed:mineModel.imgName];
    
    self.titleLbl.text = mineModel.text;

    self.rightLabel.text = mineModel.rightText;
    
}

@end
