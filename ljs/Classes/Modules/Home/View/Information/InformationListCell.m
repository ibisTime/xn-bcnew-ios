//
//  InformationListCell.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "InformationListCell.h"

//Category
#import "NSString+Date.h"
#import <UIImageView+WebCache.h>

@interface InformationListCell()
//缩略图
@property (nonatomic, strong) UIImageView *infoIV;
//标题
@property (nonatomic, strong) UILabel *titleLbl;
//时间
@property (nonatomic, strong) UILabel *timeLbl;
//收藏数
@property (nonatomic, strong) UILabel *collectNumLbl;

@end

@implementation InformationListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //缩略图
    self.infoIV = [[UIImageView alloc] init];
    
    self.infoIV.contentMode = UIViewContentModeScaleAspectFill;
    self.infoIV.clipsToBounds = YES;
    
    [self addSubview:self.infoIV];
    //标题
    self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kTextColor
                                                 font:15.0];
    self.titleLbl.numberOfLines = 0;
    
    [self addSubview:self.titleLbl];
    //时间
    self.timeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor2
                                                font:13.0];
    [self addSubview:self.timeLbl];
    //收藏数
    self.collectNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor2
                                                      font:13.0];
    
    self.collectNumLbl.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:self.collectNumLbl];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    CGFloat x = 15;
    
    //缩略图
    [self.infoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-x));
        make.top.equalTo(@10);
        make.width.equalTo(@100);
        make.height.equalTo(@80);
    }];
    //标题
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.infoIV.mas_top);
        make.left.equalTo(@(x));
        make.right.equalTo(self.infoIV.mas_left).offset(-10);
        make.height.lessThanOrEqualTo(@60);
    }];
    //时间
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(x));
        make.bottom.equalTo(self.infoIV.mas_bottom).offset(0);
    }];
    //收藏数
    [self.collectNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.infoIV.mas_left).offset(-10);
        make.centerY.equalTo(self.timeLbl.mas_centerY);
    }];
}

#pragma mark - Setting
- (void)setInfoModel:(InformationModel *)infoModel {
    
    _infoModel = infoModel;
    
    self.titleLbl.text = infoModel.title;
    [self.infoIV sd_setImageWithURL:[NSURL URLWithString:infoModel.pic] placeholderImage:kImage(PLACEHOLDER_SMALL)];
    self.timeLbl.text = [infoModel.time convertToDetailDate];
    self.collectNumLbl.text = [NSString stringWithFormat:@"%ld个收藏", infoModel.collectNum];
}

@end
