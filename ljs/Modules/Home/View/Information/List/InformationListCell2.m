//
//  InformationListCell2.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/19.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "InformationListCell2.h"
//Category
#import "NSString+Date.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import "UILabel+Extension.h"

@interface InformationListCell2()
//缩略图
@property (nonatomic, strong) UIImageView *infoIV;
//标题
@property (nonatomic, strong) UILabel *titleLbl;
//时间
@property (nonatomic, strong) UILabel *timeLbl;
//收藏数
@property (nonatomic, strong) UILabel *collectNumLbl;

@property (nonatomic, strong) UIButton *seeNumber;

//图片数组
@property (nonatomic, strong) NSMutableArray <UIImageView *>*picIVArr;

@end

@implementation InformationListCell2

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.picIVArr = [NSMutableArray array];
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //标题
    self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kTextColor
                                                 font:15.0];
    self.titleLbl.numberOfLines = 0;
    
    [self addSubview:self.titleLbl];
    
    //缩略图
    for (int i = 0; i < 3; i++) {
        
        UIImageView *infoIV = [[UIImageView alloc] init];
        
        infoIV.contentMode = UIViewContentModeScaleAspectFill;
        infoIV.clipsToBounds = YES;
        infoIV.layer.cornerRadius = 4;
        
        [self addSubview:infoIV];
        [self.picIVArr addObject:infoIV];
    }
    //时间
    self.timeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor2
                                                font:13.0];
    [self addSubview:self.timeLbl];
    
    self.seeNumber = [UIButton buttonWithTitle:@"0"
                                 titleColor:[UIColor blackColor]
                            backgroundColor:kClearColor
                                  titleFont:16.0];
    [self.seeNumber setImage:[UIImage imageNamed:@"已报名浏览"] forState:UIControlStateNormal];
    [self addSubview:self.seeNumber];
//    //收藏数
//    self.collectNumLbl = [UILabel labelWithBackgroundColor:kClearColor
//                                                 textColor:kTextColor2
//                                                      font:13.0];
//
//    self.collectNumLbl.textAlignment = NSTextAlignmentRight;
//
//    [self addSubview:self.collectNumLbl];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@15);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@0);
    }];
    
}

- (void)setSubviewLayout {
    
    CGFloat x = 15;
    
    //标题
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(x));
        make.left.equalTo(@(x));
        make.right.equalTo(@(-x));
        make.height.lessThanOrEqualTo(@70);
    }];
    
    CGFloat margin = (kScreenWidth - 30 - 3*kWidth(110))/2.0;
    
    __block UIImageView *iv;
    //缩略图
    [self.picIVArr enumerateObjectsUsingBlock:^(UIImageView * _Nonnull infoIV, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [infoIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(idx*(kWidth(110) + margin)+ 15));
            make.top.equalTo(self.titleLbl.mas_bottom).offset(10);
            make.width.equalTo(@(kWidth(110)));
            make.height.equalTo(@(kWidth(100)));
        }];
        
        iv = infoIV;
    }];
    
    //时间
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(x));
        if (self.infoModel.pics.count == 0) {
            
            make.top.equalTo(self.titleLbl.mas_bottom).offset(10);

        } else {
            
            make.top.equalTo(iv.mas_bottom).offset(10);
        }
    }];
    
    [self.seeNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-x);
        make.centerY.equalTo(self.timeLbl.mas_centerY);
    }];
    //收藏数
//    [self.collectNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(self.mas_right).offset(-x);
//        make.centerY.equalTo(self.timeLbl.mas_centerY);
//    }];
}

#pragma mark - Setting
- (void)setInfoModel:(InformationModel *)infoModel {
    
    _infoModel = infoModel;
    
    [self.titleLbl labelWithTextString:infoModel.title lineSpace:5];
    [infoModel.pics enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImageView *iv = self.picIVArr[idx];
        
        [iv sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:kImage(PLACEHOLDER_SMALL)];
    }];
    
    self.timeLbl.text = [infoModel.showDatetime convertToDetailDate];
//    self.collectNumLbl.text = [NSString stringWithFormat:@"%ld 收藏", infoModel.collectCount];
    [self.seeNumber setTitle:@"10" forState:UIControlStateNormal];
    //布局
    [self setSubviewLayout];
    //
    [self layoutSubviews];
    
    infoModel.cellHeight = self.timeLbl.yy + 15;
}
- (void)setKind:(NSString *)kind
{
    if ([kind integerValue] == 2) {
        self.timeLbl.textColor = [UIColor colorWithHexString:@"#F6A623"];
    }
}

@end
