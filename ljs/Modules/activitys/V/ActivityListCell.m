//
//  ActivityListCell.m
//  ljs
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ActivityListCell.h"

#import <UIImageView+WebCache.h>

//Category
#import "AppColorMacro.h"
#import "NSString+Date.h"
#import "UILabel+Extension.h"
#import "NSString+Extension.h"

@interface ActivityListCell()
@property (nonatomic, strong) UIImageView *ActivityImg;
@property (nonatomic, strong) UILabel *ActivityTitle;
//价格
@property (nonatomic, strong) UILabel *price;

//日期
@property (nonatomic, strong) UIImageView *dateLblImg;
@property (nonatomic, strong) UILabel *dateLbl;
//阅读数量
@property (nonatomic, strong) UIImageView *readCountImg;
@property (nonatomic, strong) UILabel * readCount;
//位置
@property (nonatomic, strong) UIImageView *locationImg;
@property (nonatomic, strong) UILabel *location;




//@property (nonatomic, strong) UILabel *status;

@end
@implementation ActivityListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //活动图片
    self.ActivityImg = [[UIImageView alloc] init];
    [self addSubview:self.ActivityImg];
    
    
    //活动主题
    self.ActivityTitle = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#3A3A3A") font:17.0];
    self.ActivityTitle.numberOfLines = 0;//行数
    
    [self addSubview:self.ActivityTitle];
    
    //价格
    self.price = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#2F93ED") font:15.0];
    [self  addSubview:self.price];
    
    //日期
    self.dateLblImg = [[UIImageView alloc] initWithImage:kImage(@"已报名时间")];
    [self addSubview:self.dateLblImg];
    self.dateLbl = [UILabel labelWithBackgroundColor:kClearColor  textColor:kHexColor(@"#818181") font:14.0];
    self.ActivityTitle.numberOfLines = 0;//行数

    [self addSubview:self.dateLbl];
    
    
    //已阅
    self.readCountImg = [[UIImageView alloc] initWithImage:kImage(@"已报名浏览")];
    [self addSubview:self.readCountImg];
    self.readCount = [UILabel labelWithBackgroundColor:kClearColor  textColor:kHexColor(@"#818181") font:14.0];
    [self addSubview:self.readCount];
    
    //位置
    self.locationImg = [[UIImageView alloc] initWithImage:kImage(@"已报名地点")];
    [self addSubview:self.locationImg];
    self.location = [UILabel labelWithBackgroundColor:kClearColor  textColor:kHexColor(@"#818181") font:14.0];
    [self addSubview:self.location];


    
    
    //报名状态
//    self.status = [UILabel labelWithBackgroundColor:kClearColor  textColor:kAppCustomMainColor font:13.0];
    //collor

    //布局
    [self setSubviewLayout];
    
}

- (void)setSubviewLayout {
    
    //
    [self.ActivityImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(15);
         make.left.offset(15);
        make.right.offset(-15);
        make.height.equalTo(@165);
        
    }];
    //标题
    [self.ActivityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.ActivityImg.mas_bottom).offset(10);
         make.left.offset(15);
        make.width.equalTo(@280);
        
        }];
    
    //价格
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        
                make.right.offset(-15);
              make.top.equalTo(self.ActivityImg.mas_bottom).offset(10);
    }];

    //日期图
    [self.dateLblImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(15);
        make.top.equalTo(self.ActivityTitle.mas_bottom).offset(5);

    }];
   
    //日期
    [self.dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.ActivityTitle.mas_bottom).offset(5);
        make.left.equalTo(self.dateLblImg.mas_right) .offset(5);
                make.width.equalTo(@284);

    }];

    //浏览量图
    [self.readCountImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-46);
        make.centerY.equalTo(self.dateLbl.mas_centerY);
    }];
    
    //浏览量
    [self.readCount mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-15);
        make.centerY.equalTo(self.dateLbl.mas_centerY);
        
    }];

    
    //位置图
    [self.locationImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(15);
make.top.equalTo(self.dateLblImg.mas_bottom).offset(5);
    }];

    
    //位置
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.dateLbl.mas_bottom).offset(5);
        make.left.equalTo(self.locationImg.mas_right) .offset(5);
    }];
    

   
//    [self.status mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerY.equalTo(self.mas_centerY);
//        make.right.offset(-35);
//
//
//    }];
//
//
}

#pragma mark - Setting
-(void)setActModel:(activityModel *)actModel
{
    _actModel  = actModel;
    ;
    [self.ActivityImg sd_setImageWithURL:[NSURL URLWithString:actModel.advPic] placeholderImage:[UIImage imageNamed:@"1513759741.41"]];
//    self.ActivityImg.image =[UIImage imageNamed: actModel.advPic];
    self.ActivityTitle.text = actModel.title;
    self.price.text =[NSString stringWithFormat:@"￥ %@",actModel.price];
    self.dateLbl.text = [NSString stringWithFormat:@"%@-%@",actModel.startDatetime,actModel.endDatetime];
    
    self.readCount.text = actModel.readCount;
    self.location.text = actModel.address;

    
    
}






- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
