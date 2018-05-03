//
//  UserEditCell.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/20.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "UserEditCell.h"

@interface UserEditCell()
//右箭头
@property (nonatomic, strong) UIImageView *arrowIV;

@end

@implementation UserEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    
    }
    return self;
}

#pragma mark - Events
- (void)initSubviews {
    
    //标题
    self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kTextColor
                                                 font:16.0];
    
    [self.contentView addSubview:self.titleLbl];
    
    //内容
    self.contentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor
                                                   font:16.0];
    
    [self.contentView addSubview:self.contentLbl];
    
    self.userPhoto = [[UIImageView alloc] init];
    [self.contentView addSubview:self.userPhoto];
    self.userPhoto.contentMode = UIViewContentModeScaleAspectFill;
    self.userPhoto.layer.cornerRadius = 30.0;
    self.userPhoto.clipsToBounds = YES;
    
    //右边箭头
    self.arrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
    [self.contentView addSubview:self.arrowIV];
    //
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lineColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.height.equalTo(@(kLineHeight));
        make.bottom.equalTo(@0);
    }];
    
    _lineView = line;
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    //
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.lessThanOrEqualTo(self.contentLbl.mas_left);
    }];
    //
    [self.arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@7);
        make.height.equalTo(@12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        
    }];
    //
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.arrowIV.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.greaterThanOrEqualTo(self.titleLbl.mas_right);
    }];
    
    //
    [self.userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.right.equalTo(self.arrowIV.mas_left).offset(-10);
        make.width.equalTo(@60);
    }];
}

@end
