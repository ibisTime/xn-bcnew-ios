//
//  WarningCurrencyView.m
//  ljs
//
//  Created by zhangfuyu on 2018/5/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "WarningCurrencyView.h"
#import "TLTextField.h"
@interface WarningCurrencyView ()

@property (nonatomic , strong)UIButton *RMBBtn;
@property (nonatomic , strong)UIButton *SCDBtn;

@property (nonatomic , strong)TLTextField *upTextFiled;
@property (nonatomic , strong)TLTextField *downTextFiled;
@property (nonatomic)BOOL isRMB;
@end

@implementation WarningCurrencyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubview];
        self.isRMB = NO;
    }
    return self;
}
- (void)creatSubview
{
    UILabel *danwei = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:[UIColor blackColor]
                                                   font:16.0];
    danwei.text = @"单位";
    danwei.textAlignment = NSTextAlignmentLeft;
    [self addSubview:danwei];
    
    
    
    
    self.RMBBtn = [UIButton buttonWithTitle:@"人民币(¥)"
                                       titleColor:[UIColor blackColor]
                                  backgroundColor:kClearColor
                                        titleFont:16.0];
    [self.RMBBtn addTarget:self action:@selector(settingWarning:) forControlEvents:UIControlEventTouchUpInside];
    [self.RMBBtn setImage:kImage(@"未选中NO") forState:UIControlStateNormal];
    
    [self addSubview:self.RMBBtn];
    [self.RMBBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.height.equalTo(@30);
        make.width.equalTo(@100);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
    [self.RMBBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
    self.SCDBtn = [UIButton buttonWithTitle:@"美元($)"
                                       titleColor:[UIColor blackColor]
                                  backgroundColor:kClearColor
                                        titleFont:16.0];
    [self.SCDBtn addTarget:self action:@selector(settingWarning:) forControlEvents:UIControlEventTouchUpInside];
    [self.SCDBtn setImage:kImage(@"选中YE") forState:UIControlStateNormal];

    [self addSubview:self.SCDBtn];
    [self.SCDBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.height.equalTo(@30);
        make.width.equalTo(@100);
        make.right.equalTo(self.RMBBtn.mas_left).with.offset(-10);
    }];
    [self.SCDBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
    [danwei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.height.equalTo(@16);
        make.centerY.equalTo(self.SCDBtn.mas_centerY);
    }];
    
    
    UIView *lineview = [[UIView alloc]init];
    lineview.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    [self addSubview:lineview];
    
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(self.SCDBtn.mas_bottom).with.offset(10);
        make.height.equalTo(@1);

    }];
    
    self.upTextFiled = [[TLTextField alloc]initWithFrame:CGRectZero leftTitle:@"$" titleWidth:30 placeholder:@""];
    self.upTextFiled.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.upTextFiled];
    self.upTextFiled.keyboardType = UIKeyboardTypeDecimalPad;
    self.upTextFiled.textColor = [UIColor blackColor];
    self.upTextFiled.layer.borderWidth = .5;
    self.upTextFiled.layer.borderColor = [UIColor colorWithHexString:@"#979797"].CGColor;
    self.upTextFiled.layer.cornerRadius = 4;
    
    UIView *rightBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addbtn.frame = CGRectMake(0, 0, 44, 44);
    [addbtn setImage:kImage(@"addRightView") forState:UIControlStateNormal];
    addbtn.tag = 100002;
    [rightBgView addSubview:addbtn];
    [addbtn addTarget:self action:@selector(addwarning:) forControlEvents:UIControlEventTouchUpInside];
    self.upTextFiled.rightView = rightBgView;
    
    
    
    [self.upTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineview.mas_bottom).with.offset(20);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.height.equalTo(@44);
        make.left.equalTo(self.mas_left).with.offset(80);
    }];
    
    
    
    
    self.downTextFiled = [[TLTextField alloc]initWithFrame:CGRectZero leftTitle:@"$" titleWidth:30 placeholder:@""];
    self.downTextFiled.font = [UIFont systemFontOfSize:16];
    self.downTextFiled.keyboardType = UIKeyboardTypeDecimalPad;
    [self addSubview:self.downTextFiled];
    self.downTextFiled.layer.borderWidth = .5;
    self.downTextFiled.layer.borderColor = [UIColor colorWithHexString:@"#979797"].CGColor;
    self.downTextFiled.layer.cornerRadius = 4;
    self.downTextFiled.textColor = [UIColor blackColor];
    
    UIView *rightBgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    UIButton *addbtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    addbtn2.frame = CGRectMake(0, 0, 44, 44);
    [addbtn2 setImage:kImage(@"addRightView") forState:UIControlStateNormal];
    [addbtn2 addTarget:self action:@selector(addwarning:) forControlEvents:UIControlEventTouchUpInside];
    addbtn2.tag = 100001;
    [rightBgView2 addSubview:addbtn2];
    
    [self.downTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upTextFiled.mas_bottom).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.height.equalTo(@44);
        make.left.equalTo(self.mas_left).with.offset(80);
    }];
    self.downTextFiled.rightView = rightBgView2;
    
    
    
    
    
    UILabel *uplabel = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:[UIColor blackColor]
                                                    font:16.0];
    uplabel.text = @"上涨至";
    uplabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:uplabel];
    
    UILabel *downlabel = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:[UIColor blackColor]
                                                    font:16.0];
    downlabel.text = @"下跌至";
    downlabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:downlabel];
    
    [uplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(self.upTextFiled.mas_top);
        make.right.equalTo(self.upTextFiled.mas_left);
        make.centerY.equalTo(self.upTextFiled.mas_centerY);
        make.height.equalTo(@44);
    }];
    [downlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.downTextFiled.mas_top);
        make.right.equalTo(self.downTextFiled.mas_left);
        make.centerY.equalTo(self.downTextFiled.mas_centerY);
        make.height.equalTo(@44);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
}

- (void)settingWarning:(UIButton *)sender
{
    
    if (sender == self.RMBBtn) {
        [self.RMBBtn setImage:kImage(@"选中YES") forState:UIControlStateNormal];
        [self.SCDBtn setImage:kImage(@"未选中NO") forState:UIControlStateNormal];
        self.upTextFiled.leftLbl.text = @"¥";
        self.downTextFiled.leftLbl.text = @"¥";
        self.isRMB = YES;
        
    }
    else
    {
        [self.SCDBtn setImage:kImage(@"选中YES") forState:UIControlStateNormal];
        [self.RMBBtn setImage:kImage(@"未选中NO") forState:UIControlStateNormal];
        self.upTextFiled.leftLbl.text = @"$";
        self.downTextFiled.leftLbl.text = @"$";
        self.isRMB = NO;
    }
}
- (void)addwarning:(UIButton *)sender
{
    [self endEditing:YES];
    
    BOOL isUp;
    NSString *text = @"";
    if (sender.tag == 100001) {
        //下跌
        isUp = NO;
        text = self.downTextFiled.text;
    }
    else
    {
        //上涨
        isUp = YES;
        text = self.upTextFiled.text;
    }
    if (text.length == 0) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(addWarning:isRmb:isUp:)]) {
        [self.delegate addWarning:text isRmb:self.isRMB isUp:isUp];
    }
}
@end
