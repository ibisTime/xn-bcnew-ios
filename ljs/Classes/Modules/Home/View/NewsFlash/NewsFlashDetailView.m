//
//  NewsFlashDetailView.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/19.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "NewsFlashDetailView.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Category
#import "UILabel+Extension.h"
#import "NSString+Date.h"
#import <UIScrollView+TLAdd.h>
//
#import "SGQRCodeTool.h"

@interface NewsFlashDetailView()
//内容
@property (nonatomic, strong) UILabel *contentLbl;
//时间
@property (nonatomic, strong) UILabel *timeLbl;
//icon
@property (nonatomic, strong) UIImageView *iconIV;
//二维码
@property (nonatomic, strong) UIImageView *qrCodeIV;
//text
@property (nonatomic, strong) UILabel *textLbl;
//
@property (nonatomic, strong) UIImageView *timeIconIV;

@end

@implementation NewsFlashDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
    }
    return self;
}
#pragma mark - Init
- (void)initSubviews {
    
    if (@available(iOS 11.0, *)) {
        
        [self adjustsContentInsets];
    }
    
    self.backgroundColor = kWhiteColor;
    
    //icon
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"消息分享")];
    
    iconIV.frame = CGRectMake(0, 0, kScreenWidth, kWidth(170));
    iconIV.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:iconIV];
    self.iconIV = iconIV;
    //内容
    self.contentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor
                                                   font:17.0];
    
    self.contentLbl.numberOfLines = 0;
    
    [self addSubview:self.contentLbl];
    //时间
    self.timeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                             textColor:kTextColor2
                                                                  font:14.0];
    
    self.timeLbl.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:self.timeLbl];
    
    UIImageView *timeIconIV = [[UIImageView alloc] initWithImage:kImage(@"时间")];
    
    timeIconIV.frame = CGRectMake(0, 0, kScreenWidth, kWidth(170));
    
    [self addSubview:timeIconIV];
    
    self.timeIconIV = timeIconIV;
    //二维码
    CGFloat qrViewW = kScreenWidth - kWidth(110);
    
    self.qrCodeIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, qrViewW, qrViewW)];
    
    [self addSubview:self.qrCodeIV];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor2
                                                     font:14.0];
    
    textLbl.text = @"更多资讯请下载\n链接社APP";
    textLbl.numberOfLines = 0;
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:textLbl];
    self.textLbl = textLbl;
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    //内容
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.top.equalTo(self.iconIV.mas_bottom).offset(25);
        make.width.equalTo(@(kScreenWidth - 30));
    }];
    //时间
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentLbl.mas_right);
        make.top.equalTo(self.contentLbl.mas_bottom).offset(25);
    }];
    [self.timeIconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.timeLbl.mas_left).offset(-10);
        make.centerY.equalTo(self.timeLbl.mas_centerY);
    }];
    //二维码
    [self.qrCodeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(self.contentLbl.mas_bottom).offset(135);
        make.width.height.equalTo(@70);
    }];
    //text
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.qrCodeIV.mas_centerY);
        make.left.equalTo(self.qrCodeIV.mas_right).offset(10);
    }];
}

- (void)setUrl:(NSString *)url {
    
    _url = url;
    
    UIImage *image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:url
                                                     imageViewWidth:kScreenWidth];
    self.qrCodeIV.image = image;
}

#pragma mark - Setting
- (void)setFlashModel:(NewsFlashModel *)flashModel {
    
    _flashModel = flashModel;
    
    [self.contentLbl labelWithTextString:[NSString stringWithFormat:@"【快讯】%@", flashModel.content] lineSpace:5];
    //星期
    NSString *weekday = [NSString weekdayStringFromDate:flashModel.showDatetime];
    NSString *time = [flashModel.showDatetime convertDateWithFormat:@"yyyy-M-d HH:mm:ss"];
    self.timeLbl.text = [NSString stringWithFormat:@"%@ %@", weekday, time];
    //
    [self layoutIfNeeded];
    
    self.contentSize = CGSizeMake(kScreenWidth, self.qrCodeIV.yy + 45);
}

@end
