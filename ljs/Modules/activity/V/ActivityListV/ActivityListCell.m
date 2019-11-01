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
@property (nonatomic, strong) UIImageView *isTopView;

//日期
@property (nonatomic, strong) UIImageView *dateLblImg;
@property (nonatomic, strong) UILabel *dateLbl;
//阅读数量
@property (nonatomic, strong) UIImageView *readCountImg;
@property (nonatomic, strong) UILabel * readCount;
//位置
@property (nonatomic, strong) UIImageView *locationImg;
@property (nonatomic, strong) UILabel *location;


@property (nonatomic, strong) UIButton *stateView;
@property (nonatomic, strong) UILabel *stateLable;

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
    
    UIButton *stateView = [[UIButton alloc] init];
    self.stateView =stateView;
    [self addSubview:stateView];
    stateView.titleLabel.font = [UIFont systemFontOfSize:14];
    //活动主题
    self.ActivityTitle = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#3A3A3A") font:17.0];
    self.ActivityTitle.numberOfLines = 0;//行数
    
    [self addSubview:self.ActivityTitle];
    
    //价格
    self.price = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#FFA300") font:15.0];
    [self  addSubview:self.price];
    self.price.textAlignment = NSTextAlignmentRight;
    
    //日期
    self.dateLblImg = [[UIImageView alloc] initWithImage:kImage(@"已报名时间")];
    [self addSubview:self.dateLblImg];
    self.dateLbl = [UILabel labelWithBackgroundColor:kClearColor  textColor:kHexColor(@"#818181") font:14.0];
    self.ActivityTitle.numberOfLines = 0;//行数

    [self addSubview:self.dateLbl];
    
    self.isTopView = [[UIImageView alloc] initWithImage:kImage(@"top")];
    [self addSubview:self.isTopView];
    //已阅
    self.readCountImg = [[UIImageView alloc] initWithImage:kImage(@"已报名浏览")];
    [self addSubview:self.readCountImg];
    self.readCount = [UILabel labelWithBackgroundColor:kClearColor  textColor:kHexColor(@"#818181") font:14.0];
    [self addSubview:self.readCount];
    self.readCount.textAlignment = NSTextAlignmentRight;
    
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
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(15);
        make.left.offset(15);
        make.width.offset(58);
        make.height.equalTo(@24);
        
    }];
   

    //标题
    [self.ActivityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.ActivityImg.mas_bottom).offset(10);
         make.left.offset(10);
        make.top.equalTo(self.ActivityImg.mas_bottom).offset(10);

        make.width.equalTo(@(kWidth(200)));
//        make.height.equalTo(@44);

        }];
    
    //价格
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        
                make.right.offset(-15);
        make.left.equalTo(self.ActivityTitle.mas_right).offset(15);
              make.top.equalTo(self.ActivityImg.mas_bottom).offset(10);
    }];
    [self.isTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-15);
        make.top.equalTo(self.price.mas_bottom).offset(10);
    }];
    //日期图
    [self.dateLblImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(15);
        make.top.equalTo(self.ActivityTitle.mas_bottom).offset(10);

    }];
   
    //日期
    [self.dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.dateLblImg.mas_centerY);
        make.left.equalTo(self.dateLblImg.mas_right).offset(5);
                make.width.equalTo(@284);

    }];

    

    
    //位置图
    [self.locationImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(15);
        make.top.equalTo(self.dateLblImg.mas_bottom).offset(9);
    }];

    
    //位置
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.locationImg.mas_centerY);
        make.left.equalTo(self.locationImg.mas_right) .offset(5);
        make.width.equalTo(@284);

    }];
    
    //浏览量图
    [self.readCountImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-46);
        make.centerY.equalTo(self.locationImg.mas_centerY);
    }];
    
    //浏览量
    [self.readCount mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.locationImg.mas_centerY);
        
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
    [self.ActivityImg sd_setImageWithURL:[NSURL URLWithString:[actModel.advPic convertImageUrl]] placeholderImage:[UIImage imageNamed:@"占位图"]];
    NSString *state = [NSString stringWithFormat:@"%@",actModel.isEnroll];
    if ([state isEqualToString:@"9"]) {
        [self.stateView setTitle:@"已结束" forState:UIControlStateNormal];
        [self.stateView setBackgroundImage:[UIImage imageNamed:@"黄"] forState:UIControlStateNormal];
//        [self.stateView setBackgroundColor:kRiseColor forState:UIControlStateNormal];
    }else if([state isEqualToString:@"1"] ||[state isEqualToString:@"2"])
    {
      
        [self.stateView setTitle:@"已报名" forState:UIControlStateNormal];
        [self.stateView setBackgroundImage:[UIImage imageNamed:@"绿"] forState:UIControlStateNormal];
//        [self.stateView setBackgroundColor:kStateColor forState:UIControlStateNormal];

    }else{
        [self.stateView setTitle:@"" forState:UIControlStateNormal];

        [self.stateView setBackgroundColor:kClearColor forState:UIControlStateNormal];

    }
  
//    self.ActivityImg.image =[UIImage imageNamed: actModel.advPic];
    
    
    self.ActivityTitle.text = actModel.title;
    if ([actModel.price isEqualToString:@"0"]|| [actModel.price isEqualToString:@"免费"] || !actModel.price ||[actModel.price isEqualToString:@""]) {
        self.price.text =[NSString stringWithFormat:@"免费"];
    }else{
        
        NSString * str =[NSString stringWithFormat:@"￥%.2f",[actModel.price floatValue]];
        if ([str isEqualToString:@"0.00"]) {
            self.price.text =[NSString stringWithFormat:@"免费"];

            return;
        }

        self.price.text =[NSString stringWithFormat:@"￥%@",actModel.price];
    }
    self.dateLbl.text = [NSString stringWithFormat:@"%@-%@",[actModel.startDatetime convertDate ],[actModel.endDatetime convertDate]];
    self.isTopView.hidden = [actModel.isTop isEqualToString:@"0"];
    if (self.isTopView.hidden ==YES) {
        
    }
   
    //完全相等（NSOrderedDescending，NSOrderedAscending，NSOrderedSame这三个是一个枚举类型）
    self.readCount.text = actModel.readCount;
    self.location.text = actModel.meetAddress;
    [self layoutIfNeeded];
    self.cellRowHeight =   CGRectGetMaxY(self.location.frame);
    NSLog(@"cellRowHeight%f",self.cellRowHeight);
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
