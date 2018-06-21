//
//  ActivityListTakeCell.m
//  ljs
//
//  Created by shaojianfei on 2018/5/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ActivityListTakeCell.h"

//Category
#import "NSString+Date.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import "UILabel+Extension.h"
@interface ActivityListTakeCell()
//缩略图
@property (nonatomic, strong) UIImageView *infoIV;
//标题
@property (nonatomic, strong) UILabel *titleLbl;
//时间
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *timeLb2;

@property (nonatomic, strong) UILabel *timeLine;
@property (nonatomic, strong) UIImageView *dateLblImg;

@property (nonatomic, strong) UIImageView *readCountImg;
@property (nonatomic, strong) UIImageView *locationImg;
@property (nonatomic, strong) UILabel *location;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong)  UIButton *stateView;
@property (nonatomic, strong)  UILabel *stateLable;

//收藏数
@property (nonatomic, strong) UILabel *collectNumLbl;
@end

@implementation ActivityListTakeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
//    UIView *stateView = [[UIView alloc] init];
//    self.stateView =stateView;
//    [self addSubview:stateView];
    
    //缩略图
    self.infoIV = [[UIImageView alloc] init];
    
    self.infoIV.contentMode = UIViewContentModeScaleAspectFill;
    self.infoIV.clipsToBounds = YES;
    self.infoIV.layer.cornerRadius = 4;
    
    [self addSubview:self.infoIV];
    
   
    UIButton *stateView = [[UIButton alloc] init];
    self.stateView =stateView;
    [self addSubview:stateView];
    stateView.titleLabel.font = [UIFont systemFontOfSize:14];
    UILabel *stateLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    self.stateLable = stateLable;
    [self addSubview:stateLable];
    //标题
    self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kTextColor
                                                 font:14.0];
    self.titleLbl.numberOfLines = 0;
    
    [self addSubview:self.titleLbl];
    //时间
    self.timeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor2
                                                font:12.0];
    [self addSubview:self.timeLbl];
    self.dateLblImg = [[UIImageView alloc] init];
    
    self.timeLb2 = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor2
                                                font:12.0];
    [self addSubview:self.timeLb2];
    self.timeLine = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor2
                                                font:12.0];
    [self addSubview:self.timeLine];
    
    
    self.dateLblImg = [[UIImageView alloc] initWithImage:kImage(@"已报名时间")];
    [self addSubview:self.dateLblImg];
    
    self.locationImg =  [[UIImageView alloc] initWithImage:kImage(@"已报名地点")];
    [self addSubview:self.locationImg];

    //收藏数
    self.readCountImg = [[UIImageView alloc] initWithImage:kImage(@"已报名浏览")];
    [self addSubview:self.readCountImg];
    self.collectNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor2
                                                      font:12.0];
    
    self.collectNumLbl.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:self.collectNumLbl];
    self.location = [UILabel labelWithBackgroundColor:kClearColor  textColor:kHexColor(@"#818181") font:12.0];
//     self.location.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.location sizeToFit];
    [self addSubview:self.location];
    //bottomLine
    //价格
    self.price = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#FFA000") font:12.0];
    [self  addSubview:self.price];
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
        
        make.left.equalTo(@(x));
        make.top.equalTo(@10);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(x);
        make.top.offset(10);
        make.width.offset(58);
        make.height.equalTo(@24);
        
    }];
    
    
//    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(@(x));
//        make.top.equalTo(@10);
//        make.width.equalTo(@58);
//        make.height.equalTo(@23);
//    }];
    [self.stateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(x+23));
        make.top.equalTo(@10);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
    }];
    //标题
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.infoIV.mas_top);
        make.right.equalTo(@(-x));
        make.left.equalTo(self.infoIV.mas_right).offset(5);
        make.height.lessThanOrEqualTo(@44);
    }];
    
    [self.dateLblImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl.mas_left);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(10);

    }];
    //时间
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.dateLblImg.mas_right).offset(2);
        make.centerY.equalTo(self.dateLblImg.mas_centerY).offset(0);
    }];
    
    [self.timeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLbl.mas_right).offset(2);
        make.centerY.equalTo(self.timeLbl.mas_centerY);
        
    }];
    [self.timeLb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLine.mas_right).offset(2);
        make.centerY.equalTo(self.timeLine.mas_centerY);
    }];
    [self.locationImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLblImg.mas_bottom).offset(15);
        make.left.equalTo(self.infoIV.mas_right).offset(5);
    }];
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationImg.mas_right).offset(5);
        make.centerY.equalTo(self.locationImg.mas_centerY);

    }];
    [self.readCountImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.location.mas_bottom).offset(13);
        make.left.equalTo(self.infoIV.mas_right).offset(5);
    }];
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.location.mas_bottom).offset(10);
        make.right.equalTo(@(-10));
        
    }];
    //收藏数
    [self.collectNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.readCountImg.mas_right).offset(5);
        make.top.equalTo(self.location.mas_bottom).offset(10);
    }];
}

#pragma mark - Setting
- (void)setInfoModel:(ActivityListModel *)infoModel {
    
    _infoModel = infoModel;
    
   /* [self.ActivityImg sd_setImageWithURL:[NSURL URLWithString:[actModel.advPic convertImageUrl]] placeholderImage:[UIImage imageNamed:@"1513759741.41"]];
    self.ActivityTitle.text = actModel.title;
    if ([actModel.price isEqualToString:@"0"]) {
        self.price.text =[NSString stringWithFormat:@"免费"];
    }else{
        self.price.text =[NSString stringWithFormat:@"￥ %@",actModel.price];
    }
    self.dateLbl.text = [NSString stringWithFormat:@"%@-%@",[actModel.startDatetime convertDate ],[actModel.endDatetime convertDate]];
    self.isTopView.hidden = [actModel.isTop isEqualToString:@"0"];
    self.readCount.text = actModel.readCount;
    self.location.text = actModel.address;
    [self layoutIfNeeded];
    self.cellRowHeight =   CGRectGetMaxY(self.location.frame);
    */
   
    [self.titleLbl labelWithTextString:infoModel.title lineSpace:5];
    [self.infoIV sd_setImageWithURL:[NSURL URLWithString:[infoModel.advPic convertImageUrl]] placeholderImage:kImage(PLACEHOLDER_SMALL)];
    
    NSString *state = [NSString stringWithFormat:@"%@",infoModel.status];
    if ([state isEqualToString:@"9"]) {
        [self.stateView setTitle:@"已结束" forState:UIControlStateNormal];
        [self.stateView setBackgroundImage:[UIImage imageNamed:@"黄"] forState:UIControlStateNormal];
        //        [self.stateView setBackgroundColor:kRiseColor forState:UIControlStateNormal];
    }else
    {
        
        [self.stateView setTitle:@"已报名" forState:UIControlStateNormal];
        [self.stateView setBackgroundImage:[UIImage imageNamed:@"绿"] forState:UIControlStateNormal];
        //        [self.stateView setBackgroundColor:kStateColor forState:UIControlStateNormal];
        
    }
    self.timeLbl.text = [infoModel.startDatetime convertDate];
    self.timeLine.text = @"-";
    self.timeLb2.text = [infoModel.endDatetime convertDate];
    self.collectNumLbl.text = [NSString stringWithFormat:@"%@", infoModel.readCount];
    self.location.text = infoModel.meetAddress;
    if ([infoModel.price isEqualToString:@"0"] || [infoModel.price isEqualToString:@"免费"]|| [infoModel.price isEqualToString:@""] ) {
        
        self.price.text = @"免费";
        return;
    }
    self.price.text= [NSString stringWithFormat:@"%@", infoModel.price ];;
}
@end
