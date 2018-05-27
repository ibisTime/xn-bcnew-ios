//
//  initDetailActHead.m
//  ljs
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "initDetailActHead.h"
#import "NSString+Extension.h"


//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
@interface initDetailActHead()

@property (nonatomic, strong) UIImageView *titleImg;

@property (nonatomic, strong) UILabel *titleDet;
@property (nonatomic, strong) UIImageView * readCountImg;
@property (nonatomic, strong) UILabel * readCountDet;
@property (nonatomic,strong) UILabel * priceDet;

@end
@implementation initDetailActHead

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.backgroundColor = [UIColor clearColor];
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    //1
    self.titleImg = [[UIImageView alloc] init];
    self.titleImg.backgroundColor = kClearColor;
    [self addSubview:self.titleImg];
    
    [self.titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);

        make.height.equalTo(@180);
        
    }];
    //2
    self.titleDet = [UILabel labelWithBackgroundColor:kClearColor textColor:kBlackColor font:17];
    self.titleDet.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleDet];
    
    
    [self.titleDet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleImg.mas_bottom).offset(10);
        make.left.offset(15);
        make.right.offset(15);
        
    }];
    //3
    self.readCountImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"活动详情浏览"]];
    [self addSubview:self.readCountImg];
    
    [self.readCountImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-14);
        make.left.offset(15);
    }];
    
    //4
    self.readCountDet = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#818181") font:14];
    [self addSubview:self.readCountDet];
    
    [self.readCountDet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.readCountImg.mas_right).offset(5);
        make.centerY.equalTo(self.readCountImg.mas_centerY);
    }];
    
    //5
    self.priceDet = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#2F93ED") font:15];
    [self addSubview:self.priceDet];
    
    [self.priceDet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.readCountImg.mas_centerY);
        make.right.offset(-15);
    }];
    
    
    
    
}


#pragma mark - sourse
-(void)setDetailActModel:(DetailActModel *)detailActModel
{
    _detailActModel = detailActModel;
    [self.titleImg  sd_setImageWithURL:[NSURL URLWithString:[detailActModel.advPic convertImageUrl]] placeholderImage:[UIImage imageNamed:@"1513759741.41"]];
    self.titleDet.text = detailActModel.title;
    self.readCountDet.text = detailActModel.readCount;
    self.priceDet.text = [NSString stringWithFormat:@"¥%.2f" ,[detailActModel.price doubleValue]/1000];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
