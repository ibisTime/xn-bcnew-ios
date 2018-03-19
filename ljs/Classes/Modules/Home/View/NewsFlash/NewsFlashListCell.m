//
//  NewsFlashListCell.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "NewsFlashListCell.h"
//Category
#import "NSString+Date.h"

@interface NewsFlashListCell()

//时间
@property (nonatomic, strong) UILabel *timeLbl;
//标题
@property (nonatomic, strong) UILabel *titleLbl;
//内容
@property (nonatomic, strong) UILabel *contentLbl;

@end

@implementation NewsFlashListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //时间
    self.timeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor2
                                                  font:13.0];
    self.timeLbl.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:self.timeLbl];
    
    //标题
    self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor
                                                   font:15.0];
    
    [self addSubview:self.titleLbl];
    //内容
    self.contentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor
                                                     font:15.0];
    
    self.contentLbl.numberOfLines = 3;
    
    [self addSubview:self.contentLbl];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    CGFloat x = 15;
    //时间
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@10);
        make.right.equalTo(@(-x));
        make.width.lessThanOrEqualTo(@140);
    }];
    //标题
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(x));
        make.centerY.equalTo(self.timeLbl.mas_centerY);
        make.right.equalTo(self.timeLbl.mas_left).offset(-10);
    }];
    //内容
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLbl.mas_bottom).offset(10);
        make.left.equalTo(self.titleLbl.mas_left);
        make.right.equalTo(@(-x));
        make.height.lessThanOrEqualTo(@60);
    }];
}

#pragma mark - Setting
- (void)setFlashModel:(NewsFlashModel *)flashModel {
    
    _flashModel = flashModel;
    
    self.timeLbl.text = [flashModel.time convertToDetailDate];
    self.titleLbl.text = [NSString stringWithFormat:@"【%@】", flashModel.title];
    self.contentLbl.text = flashModel.content;
    //
    [self layoutSubviews];
    
    flashModel.cellHeight = self.contentLbl.yy + 10;
    
}

@end
