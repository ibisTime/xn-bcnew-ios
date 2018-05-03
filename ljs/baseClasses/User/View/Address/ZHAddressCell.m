//
//  ZHAddressCell.m
//  ljs
//
//  Created by  tianlei on 2016/12/29.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "ZHAddressCell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "UILabel+Extension.h"

#define ADDRESS_CHANGE_NOTIFICATION @"ADDRESS_CHANGE_NOTIFICATION"

@interface ZHAddressCell()

//姓名
@property (nonatomic,strong) UILabel *infoLbl;
//手机号
@property (nonatomic, strong) UILabel *mobileLbl;
//省市区
@property (nonatomic,strong) UILabel *addressLbl;
//详细地址
@property (nonatomic,strong) UILabel *detailAddressLbl;

@property (nonatomic,strong) UIButton *selectedBtn;


@end


@implementation ZHAddressCell

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressChangeAction:) name:ADDRESS_CHANGE_NOTIFICATION object:nil];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //1.
        self.infoLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:Font(15.0)
                                     textColor:kTextColor];
        
        [self.contentView addSubview:self.infoLbl];
        [self.infoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            make.width.mas_lessThanOrEqualTo(200);
            make.top.mas_equalTo(20);
            make.height.mas_equalTo(kFontHeight(15.0));
            
        }];
        //2.
        self.mobileLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentRight backgroundColor:kClearColor font:Font(15.0) textColor:kTextColor];
        
        [self.contentView addSubview:self.mobileLbl];
        [self.mobileLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-15);
            make.width.mas_lessThanOrEqualTo(150);
            make.top.mas_equalTo(self.infoLbl.mas_top).mas_equalTo(0);
            make.height.mas_equalTo(kFontHeight(15.0));
            
        }];
        //3.
        self.addressLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor clearColor]
                                             font:Font(13)
                                        textColor:kTextColor];
        
        self.addressLbl.numberOfLines = 0;
        
        [self.contentView addSubview:self.addressLbl];
        [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.infoLbl.mas_left);
            make.right.equalTo(self.mobileLbl.mas_right);
            make.top.equalTo(self.infoLbl.mas_bottom).offset(11);
            
        }];
        
        //
        //        self.detailAddressLbl = [UILabel labelWithFrame:CGRectMake(15, self.addressLbl.yy + 10 , self.infoLbl.width, self.addressLbl.height)
        //                                     textAligment:NSTextAlignmentLeft
        //                                  backgroundColor:[UIColor clearColor]
        //                                             font:FONT(13)
        //                                        textColor:[UIColor zh_textColor]];
        //        [self addSubview:self.detailAddressLbl];
        
        UIView *line = [[UIView alloc] init];
        
        line.backgroundColor = kLineColor;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(@(kLineHeight));
            make.top.equalTo(self.addressLbl.mas_bottom).offset(20);
        }];
        
        //
        self.selectedBtn = [UIButton buttonWithTitle:@"默认地址" titleColor:kTextColor backgroundColor:kClearColor titleFont:12.0];
        
        [self.selectedBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [self.selectedBtn addTarget:self action:@selector(selectedAddress) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.selectedBtn];
        
        [self.selectedBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(line.mas_bottom).mas_equalTo(12);
            make.left.equalTo(self.mas_left).offset(15);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(100);
        }];
        
        [self.selectedBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [self.selectedBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        
        //编辑 和 删除
        CGFloat w = 70;
        UIButton *deleteBtn = [self btnWithFrame:CGRectZero imageName:@"删除" title:@"删除"];
        [deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteBtn];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(line.mas_bottom).mas_equalTo(0);
            make.width.mas_equalTo(w);
            make.height.mas_equalTo(45);
        }];
        
        //编辑按钮
        UIButton *editBtn = [self btnWithFrame:CGRectMake(0, 110, w, deleteBtn.height) imageName:@"编辑" title:@"编辑"];
        [editBtn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:editBtn];
        [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(deleteBtn.mas_left).mas_equalTo(-15);
            make.top.mas_equalTo(line.mas_bottom).mas_equalTo(0);
            make.width.mas_equalTo(w);
            make.height.mas_equalTo(45);
        }];
        
    }
    
    return self;
    
}

- (UIButton *)btnWithFrame:(CGRect )frame imageName:(NSString *)imageName title:(NSString *)title {
    
    UIButton *editBtn = [[UIButton alloc] initWithFrame:frame];
    [self addSubview:editBtn];
    editBtn.titleLabel.font = FONT(12);
    [editBtn setTitleColor:kTextColor forState:UIControlStateNormal];
    [editBtn setTitle:title forState:UIControlStateNormal];
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [editBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return editBtn;
    
}

#pragma mark- 删除收货地址
- (void)delete {
    
    if (self.deleteAddr) {
        
        __weak typeof(self) weakSelf = self;
        self.deleteAddr(weakSelf);
    }
}

#pragma mark- 便捷收货地址
- (void)edit {
    
    if (self.editAddr) {
        
        __weak typeof(self) weakSelf = self;
        self.editAddr(weakSelf);
    }
}

- (void)addressChangeAction:(NSNotification *)noti {
    
    id obj = noti.userInfo[@"sender"];
    
    if (self.address.isSelected) {
        
        [self.selectedBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [self.selectedBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        
        return;
    }
    
    if ([obj isEqual:self]) {
        
        [self.selectedBtn setTitleColor:kAppCustomMainColor forState:UIControlStateNormal];
        [self.selectedBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    }
}

- (void)setIsDisplay:(BOOL)isDisplay {
    
    _isDisplay = isDisplay;
    
    self.selectedBtn.hidden = isDisplay;
    
}


- (void)selectedAddress {
    
    BaseWeakSelf;
    
    //已经是选中状态 return
    if (self.address.isSelected) {
        return;
    }
    
    if (self.defaultAddr) {
        
        self.defaultAddr(weakSelf);
    }
}

- (void)setAddress:(ZHReceivingAddress *)address {
    
    _address = address;
    
    self.infoLbl.text = [NSString stringWithFormat:@"%@ ",_address.addressee];
    self.mobileLbl.text = _address.mobile;
    
    [self.addressLbl labelWithTextString:[NSString stringWithFormat:@"%@ %@ %@ %@",_address.province,_address.city,_address.district, _address.detailAddress] lineSpace:5];
    
    if ([address.isDefault isEqualToString:@"1"]) {
        
        [self.selectedBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        
        [self.selectedBtn setTitleColor:kAppCustomMainColor forState:UIControlStateNormal];
    } else {
        
        [self.selectedBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [self.selectedBtn setTitleColor:kTextColor forState:UIControlStateNormal];
    }
    
    [self.contentView layoutIfNeeded];
    
    _address.cellHeight = self.selectedBtn.yy + 12;
}

@end

