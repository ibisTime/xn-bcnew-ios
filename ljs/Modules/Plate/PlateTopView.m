//
//  PlateTopView.m
//  ljs
//
//  Created by shaojianfei on 2018/6/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlateTopView.h"
#import "UILabel+Extension.h"
#import "UILable+convience.h"
@interface  PlateTopView()

@property (nonatomic ,strong) UILabel *nameLab;

@property (nonatomic ,strong) UILabel *bestLab;

@property (nonatomic ,strong) UILabel *bestlable;
@property (nonatomic ,strong) UILabel *bestlableNum;

@property (nonatomic ,strong) UILabel *worestLab;
@property (nonatomic ,strong) UILabel *worestLable;

@property (nonatomic ,strong) UILabel *worestLableNum;

@property (nonatomic ,strong) UILabel *rightNumberLab;

@property (nonatomic ,strong) UILabel *rightBottomLab;

@property (nonatomic ,strong) UILabel *upLable;

@property (nonatomic ,strong) UILabel *dowenLable;

@property (nonatomic ,strong) UILabel *numberLable;



@end
@implementation PlateTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
        //来源
        [self initLayouts];
//        //分享
//        [self initShareView];
    }
    return self;
}
- (void)initSubviews
{
    self.nameLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:17.0];
    [self addSubview:self.nameLab];
    self.bestLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    [self addSubview:self.bestLab];

    self.bestlable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    [self addSubview:self.bestlable];

    self.bestlableNum = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    [self addSubview:self.bestlableNum];


    self.worestLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    [self addSubview:self.worestLab];

    self.worestLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    [self addSubview:self.worestLable];

    self.worestLableNum = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    [self addSubview:self.worestLableNum];


    self.rightNumberLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:25.0];
    [self addSubview:self.rightNumberLab];

    self.rightBottomLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    [self addSubview:self.rightBottomLab];

    self.upLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    [self addSubview:self.upLable];

    self.dowenLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    [self addSubview:self.dowenLable];

    self.numberLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    [self addSubview:self.numberLable];

}

- (void)initLayouts
{
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@15);
    }];
    [self.bestLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom).offset(10);
        make.left.equalTo(self.nameLab.mas_left);

    }];
    
    [self.bestlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom).offset(10);
        make.left.equalTo(self.bestLab.mas_right).offset(3);
        
    }];
    [self.bestlableNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom).offset(10);
        make.left.equalTo(self.bestlable.mas_right).offset(3);
        
    }];
    [self.worestLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bestLab.mas_bottom).offset(10);
        make.left.equalTo(self.bestLab.mas_left);
        
    }];
    [self.worestLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bestLab.mas_bottom).offset(10);
        make.left.equalTo(self.worestLab.mas_right).offset(3);
        
    }];
    [self.worestLableNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bestLab.mas_bottom).offset(10);
        make.left.equalTo(self.worestLable.mas_right).offset(3);
        
    }];
   
    [self.rightNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bestLab.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        
    }];
    
    [self.rightBottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.rightNumberLab.mas_bottom).offset(10);
        
    }];
    [self.upLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.worestLab.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(15);
        
    }];
    [self.dowenLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.worestLab.mas_bottom).offset(10);
        make.left.equalTo(self.upLable.mas_right).offset(10);
        
    }];
    [self.numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.worestLab.mas_bottom).offset(10);
        make.left.equalTo(self.dowenLable.mas_right).offset(10);
        
    }];
}

-(void)setModel:(PlateMineModel *)model
{
    
    _model = model;
    self.nameLab.text = model.name;
    self.bestLab.text = @"最佳";
    if ([model.bestChange floatValue]*100 > 0) {
        self.bestlable.text = model.bestSymbol;
        self.bestlableNum.text = [NSString stringWithFormat:@"%.2f",[model.bestChange floatValue]*100];
        self.bestlableNum.textColor = kRiseColor;
    }else
    {
        self.bestlable.text = model.bestSymbol;

        self.bestlableNum.text = [NSString stringWithFormat:@"%.2f",[model.bestChange floatValue]*100];
        self.bestlableNum.textColor = kbottomColor;
    }
    
    self.worestLab.text = @"最差";
    
    if ([model.worstChange floatValue]*100 > 0) {
        self.worestLable.text = model.worstSymbol;
        self.worestLableNum.text = [NSString stringWithFormat:@"%.2f%%",[model.worstChange floatValue]*100];
        self.worestLableNum.textColor = kRiseColor;
    }else
    {
        self.worestLable.text = model.worstSymbol;

        self.worestLableNum.text = [NSString stringWithFormat:@"%.2f%%",[model.worstChange floatValue]*100];
        self.worestLableNum.textColor = kbottomColor;
    }
    
   

    if ([model.avgChange floatValue]*100 > 0) {
        self.rightNumberLab.text = [NSString stringWithFormat:@"%.2f%%",[model.avgChange floatValue]*100];
        self.rightNumberLab.textColor = kRiseColor;
    }else
    {
        self.rightNumberLab.text = [NSString stringWithFormat:@"%.2f%%",[model.avgChange floatValue]*100];
        self.rightNumberLab.textColor = kbottomColor;
        }
    self.rightBottomLab.text = @"平均涨跌幅";
    
    self.upLable.text = [NSString stringWithFormat:@"上涨币种:%@",model.upCount];
    self.dowenLable.text = [NSString stringWithFormat:@"下跌币种:%@",model.downCount];
    self.numberLable.text = [NSString stringWithFormat:@"币种数量:%@",model.totalCount];
}
@end
