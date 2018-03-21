//
//  AddOptionalCell.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AddOptionalCell.h"
//Category
#import "UILabel+Extension.h"
#import "NSString+CGSize.h"
#import "NSString+Extension.h"

@interface AddOptionalCell()
//名称
@property (nonatomic, strong) UILabel *nameLbl;
//单位
@property (nonatomic, strong) UILabel *unitLbl;
//添加
@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation AddOptionalCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //名称
    self.nameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor
                                                        font:17.0];
    
    [self addSubview:self.nameLbl];
    //单位
    self.unitLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor
                                                        font:14.0];
    
    [self addSubview:self.unitLbl];
    //添加按钮
    self.addBtn = [UIButton buttonWithImageName:@"小加" selectedImageName:@"勾选"];
    
    self.addBtn.userInteractionEnabled = NO;
    
    [self addSubview:self.addBtn];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    //名称
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        make.left.equalTo(@15);
    }];
    //单位
    [self.unitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_right).offset(6);
        make.centerY.equalTo(self.nameLbl.mas_centerY);
    }];
    //添加
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@22);
    }];
}

#pragma mark - Setting
- (void)setOptional:(OptionalModel *)optional {
    
    _optional = optional;
    
    //名称
    self.nameLbl.text = optional.symbol;
    //单位
    self.unitLbl.text = optional.unit;
    //添加按钮
    self.addBtn.selected = optional.isSelect;
    
}

@end
