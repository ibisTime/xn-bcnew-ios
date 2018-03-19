//
//  MineHeaderView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MineHeaderView.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Framework
//Category
//Extension
//M
//V
//C
@interface MineHeaderView()

@end

@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.backgroundColor = kClearColor;
    
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110 + kNavigationBarHeight)];
    
//    bgIV.image =kImage(@"我的-背景");
    bgIV.contentMode = UIViewContentModeScaleToFill;
    
    [self addSubview:bgIV];
    
    //title
    UILabel *titleLbl = [UILabel labelWithFrame:CGRectMake(0, kNavigationBarHeight - 44, kScreenWidth, 44)
                                   textAligment:NSTextAlignmentCenter
                                backgroundColor:kClearColor
                                           font:Font(18)
                                      textColor:kWhiteColor];
    
    titleLbl.text = @"我的";
    
    [self addSubview:titleLbl];
    //头像
    CGFloat imgWidth = 66;
    
    self.userPhoto = [[UIImageView alloc] init];
    
    self.userPhoto.frame = CGRectMake(15, 11 + kNavigationBarHeight, imgWidth, imgWidth);
    self.userPhoto.image = USER_PLACEHOLDER_SMALL;
    self.userPhoto.layer.cornerRadius = imgWidth/2.0;
    self.userPhoto.layer.masksToBounds = YES;
    self.userPhoto.contentMode = UIViewContentModeScaleAspectFill;
    
    self.userPhoto.userInteractionEnabled = YES;
    
    [self addSubview:self.userPhoto];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhoto:)];
    
    [self.userPhoto addGestureRecognizer:tapGR];
    
    //昵称
    self.nameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kWhiteColor
                                                font:17.0];
    
    [self addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.userPhoto.mas_top).offset(12);
        make.left.equalTo(self.userPhoto.mas_right).offset(15);
        
    }];
    //性别
    self.genderIV = [[UIImageView alloc] init];
    
    self.genderIV.contentMode = UIViewContentModeScaleAspectFill;
    self.genderIV.layer.borderWidth = 1;
    self.genderIV.layer.borderColor = kWhiteColor.CGColor;
    self.genderIV.layer.cornerRadius = 7;
    self.genderIV.clipsToBounds = YES;
    
    [self addSubview:self.genderIV];
    [self.genderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.userPhoto.mas_bottom).offset(-(imgWidth/4.0 - 5));
        make.centerX.equalTo(self.userPhoto.mas_right).offset(-(imgWidth/4.0 - 5));
    }];
    
    //角色
    self.infoLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kWhiteColor
                                                font:12.0];
    [self addSubview:self.infoLbl];
    [self.infoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(self.nameLbl.mas_bottom).offset(8);
        
    }];
    
    //箭头
    UIImageView *arrowImageView= [[UIImageView alloc] init];
    [self addSubview:arrowImageView];
    arrowImageView.image = [UIImage imageNamed:@"更多-白色"];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.userPhoto.mas_centerY).offset(0);
        
    }];
}

#pragma mark - Events

- (void)selectPhoto:(UITapGestureRecognizer *)tapGR {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
        
        [self.delegate didSelectedWithType:MineHeaderSeletedTypeSelectPhoto idx:0];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:idx:)]) {
        
        [self.delegate didSelectedWithType:MineHeaderSeletedTypeDefault idx:0];
    }
    
}

@end
