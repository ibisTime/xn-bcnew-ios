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
#import "UILabel+Extension.h"
#import "NSString+Extension.h"

@interface NewsFlashListCell()

//时间
@property (nonatomic, strong) UILabel *timeLbl;
//日期
@property (nonatomic, strong) UIButton *dateBtn;
//内容
@property (nonatomic, strong) UILabel *contentLbl;
//点
@property (nonatomic, strong) UIImageView *dotIV;
//横线
@property (nonatomic, strong) UIView *wLine;
//竖线
@property (nonatomic, strong) UIView *hLine;

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
    
    //点
    self.dotIV = [[UIImageView alloc] initWithImage:kImage(@"圆")];
    
    [self addSubview:self.dotIV];
    //横线
    self.wLine = [[UIView alloc] init];
    
    self.wLine.backgroundColor = kAppCustomMainColor;
    
    [self addSubview:self.wLine];
    //竖线
    self.hLine = [[UIView alloc] init];
    
    self.hLine.backgroundColor = kTextColor2;
    
    [self addSubview:self.hLine];
    //日期
    self.dateBtn = [UIButton buttonWithTitle:@""
                                  titleColor:kAppCustomMainColor
                             backgroundColor:kWhiteColor
                                   titleFont:10.0];
    [self.dateBtn setBackgroundImage:kImage(@"日历") forState:UIControlStateNormal];
    self.dateBtn.titleLabel.numberOfLines = 2;
    self.dateBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.dateBtn];
    //时间
    self.timeLbl = [UILabel labelWithBackgroundColor:[UIColor colorWithHexString:@"#e8f5ff"]
                                             textColor:kAppCustomMainColor
                                                  font:14.0];
    self.timeLbl.textAlignment = NSTextAlignmentCenter;
    self.timeLbl.layer.cornerRadius = 10;
    self.timeLbl.clipsToBounds = YES;
    
    [self addSubview:self.timeLbl];
    //内容
    self.contentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kAppCustomMainColor
                                                     font:15.0];
    self.contentLbl.numberOfLines = 3;
    
    [self addSubview:self.contentLbl];
    //分享
    self.shareBtn = [UIButton buttonWithTitle:@"分享"
                                   titleColor:kTextColor2
                              backgroundColor:kClearColor
                                    titleFont:14.0];
    [self.shareBtn setImage:kImage(@"分享") forState:UIControlStateNormal];
    
    [self addSubview:self.shareBtn];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    CGFloat x = 15;
    CGFloat dotW = 15;
    //点
    [self.dotIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kWidth(x)));
        make.top.equalTo(@(kWidth(x)));
        make.width.height.equalTo(@(dotW));
    }];
    //竖线
    [self.hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.dotIV.mas_centerX);
        make.width.equalTo(@(0.5));
        make.top.bottom.equalTo(@0);
    }];
    //横线
    [self.wLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.dotIV.mas_centerY);
        make.left.equalTo(self.dotIV.mas_right);
        make.height.equalTo(@0.5);
        make.width.equalTo(@(kWidth(14)));
    }];
    CGFloat scale = 1.2;
    //日期
    [self.dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.dotIV.mas_centerX);
        make.top.equalTo(@0);
        make.width.equalTo(@(25*scale));
        make.height.equalTo(@(30*scale));
    }];
    //时间
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@10);
        make.left.equalTo(self.wLine.mas_right);
        make.height.equalTo(@20);
        make.width.equalTo(@(80));
    }];
    //内容
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.timeLbl.mas_bottom).offset(10);
        make.left.equalTo(self.timeLbl.mas_left);
        make.right.equalTo(@(-x));
//        make.height.lessThanOrEqualTo(@90);
    }];
    //分享
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@10);
        make.right.equalTo(@(-x));
        make.width.equalTo(@50);
        make.height.equalTo(@20);
    }];
    [self.shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
}

#pragma mark - Setting
- (void)setFlashModel:(NewsFlashModel *)flashModel {
    
    _flashModel = flashModel;
    
    NSString *month = [flashModel.showDatetime convertDateWithFormat:@"M月"];
    NSString *day = [flashModel.showDatetime convertDateWithFormat:@"dd"];
    
    [self.dateBtn setTitle:[NSString stringWithFormat:@"%@\n%@", month, day] forState:UIControlStateNormal];
    self.dateBtn.hidden = flashModel.isShowDate;
    
    [self.dateBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    self.timeLbl.text = [flashModel.showDatetime convertDateWithFormat:@"HH:mm:ss"];
    
    //过滤特殊字符串
    NSString *content = [NSString filterHTML:flashModel.content];
    
    self.contentLbl.numberOfLines = flashModel.isSelect ? 0: 3;
    [self.contentLbl labelWithTextString:content lineSpace:5];
    
    if (self.isAll) {
        
        self.contentLbl.textColor = [flashModel.isRead isEqualToString:@"1"] ? kTextColor2: kTextColor;

    } else {
        
        self.contentLbl.textColor = [flashModel.isRead isEqualToString:@"1"] ? kTextColor2: kAppCustomMainColor;
    }
    //
    [self layoutSubviews];
    
    flashModel.cellHeight = self.contentLbl.yy + 10;
}

@end
