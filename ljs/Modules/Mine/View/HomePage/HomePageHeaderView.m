//
//  HomePageHeaderView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HomePageHeaderView.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//M
#import "TLUser.h"

@interface HomePageHeaderView()

@end

@implementation HomePageHeaderView

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
    
    //头像
    CGFloat imgWidth = 66;
    
    self.userPhoto = [[UIImageView alloc] init];
    
    self.userPhoto.frame = CGRectMake(15, 11, imgWidth, imgWidth);
    self.userPhoto.image = USER_PLACEHOLDER_SMALL;
    self.userPhoto.layer.cornerRadius = imgWidth/2.0;
    self.userPhoto.layer.masksToBounds = YES;
    self.userPhoto.contentMode = UIViewContentModeScaleAspectFill;
    
    self.userPhoto.userInteractionEnabled = YES;
    
    [self addSubview:self.userPhoto];
    //昵称
    self.nameBtn = [UIButton buttonWithTitle:@""
                                  titleColor:kWhiteColor
                             backgroundColor:kClearColor
                                   titleFont:17.0];
    [self.nameBtn addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nameBtn];
    [self.nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.userPhoto.mas_centerY);
        make.left.equalTo(self.userPhoto.mas_right).offset(15);
    }];
    
}

@end
