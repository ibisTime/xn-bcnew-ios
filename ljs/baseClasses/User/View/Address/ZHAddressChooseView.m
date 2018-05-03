//
//  ZHAddressChooseView.m
//  ljs
//
//  Created by  tianlei on 2016/12/31.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "ZHAddressChooseView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface ZHAddressChooseView()

@property (nonatomic,strong) UIImageView  *moreImgV;



@end

@implementation ZHAddressChooseView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        //
        self.backgroundColor = [UIColor whiteColor];

        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseAddressAction)];
        [self addGestureRecognizer:tap];
//        [self.headeBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.nameLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:Font(13.0)
                                     textColor:kTextColor];
        [self addSubview:self.nameLbl];
        
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(kLeftMargin);
            make.top.equalTo(self.mas_top).offset(16);
            
        }];
        
        //手机号码
        self.mobileLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentRight
                                 backgroundColor:[UIColor whiteColor]
                                            font:Font(13.0)
                                       textColor:kTextColor];
        [self addSubview:self.mobileLbl];
        
        [self.mobileLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.nameLbl.mas_right).offset(5);
            make.top.equalTo(self.nameLbl.mas_top);
            make.right.equalTo(self.mas_right).offset(-50);
        }];
        
        //地址
        self.addressLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor whiteColor]
                                             font:Font(13.0)
                                        textColor:kTextColor];
        self.addressLbl.numberOfLines = 0;
        [self addSubview:self.addressLbl];
        
        [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.nameLbl.mas_left);
            make.right.equalTo(self.mobileLbl.mas_right);
            make.top.equalTo(self.nameLbl.mas_bottom).offset(11);
        }];
        
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bbcx_更多"]];
        self.moreImgV = imgV;
        [self addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.mas_equalTo(@17);
            make.width.mas_equalTo(@10);
            make.centerY.equalTo(self.mas_centerY);
            
        }];
        
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 2)];
        line.backgroundColor = kLineColor;
        
        [self addSubview:line];
        line.image = [UIImage imageNamed:@"address_line"];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(@1);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }

    return self;
}

- (void)setType:(ZHAddressChooseType)type {

    _type = type;
    if (type == ZHAddressChooseTypeDisplay) {
        
        self.moreImgV.hidden = YES;
        
    } else {
    
        self.moreImgV.hidden = NO;
    
    }
    
}

- (void)chooseAddressAction {

    if (self.chooseAddress) {
        self.chooseAddress();
    }

}


@end
