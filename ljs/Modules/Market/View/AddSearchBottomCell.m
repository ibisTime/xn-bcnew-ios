//
//  AddSearchBottomCell.m
//  ljs
//
//  Created by shaojianfei on 2018/5/30.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AddSearchBottomCell.h"
#import "AppColorMacro.h"
#import "TLAlert.h"
#import <Masonry.h>

@interface AddSearchBottomCell()
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIButton *selectedBtn;

@end
@implementation AddSearchBottomCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        //按钮
        
        self.selectedBtn = [[UIButton alloc] init];
        [self.selectedBtn addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.selectedBtn];
        self.selectedBtn.backgroundColor = kMineBackGroundColor;
        [self.selectedBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        [self.selectedBtn setTitle:@"test" forState:UIControlStateNormal];
        [self.selectedBtn setTitle:@"test1" forState:UIControlStateSelected];
        self.selectedBtn.enabled = NO;
        self.selectedBtn.layer.cornerRadius = 4.0;
        self.selectedBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(kMineBackGroundColor);
        self.selectedBtn.layer.borderWidth=1;
        //        [self.selectedBtn setImage:[UIImage imageNamed:@"金"] forState:UIControlStateNormal];
        //        [self.selectedBtn setImage:[UIImage imageNamed:@"银"] forState:UIControlStateSelected];
        [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView.mas_top).offset(0);
            make.left.equalTo(self.contentView.mas_left).offset(0);
            make.right.mas_equalTo(self.contentView.mas_right).offset(0);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
            
        }];
        
        [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.mas_equalTo(UIEdgeInsetsMake(15, 15, 15, 15));
        }];
        
                self.photoImageView = [[UIImageView alloc] init];
                [self.contentView addSubview:self.photoImageView];
                self.photoImageView.clipsToBounds = YES;
                self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
                self.photoImageView.image = [UIImage imageNamed:@"选择勾"];
                [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.mas_right);
                    make.bottom.equalTo(self.selectedBtn.mas_bottom);
                    make.height.equalTo(@21);
                    make.width.equalTo(@21);

                }];
        
    }
    return self;
}
- (void)choose
{
    
    NSLog(@"choose");
    
}
- (void)setTitle:(CurrencyTitleModel *)title
{
    
    _title = title;
    [self.selectedBtn setTitle:title.symbol forState:UIControlStateNormal];
    if (title.IsSelect == YES) {
        [self.selectedBtn setBackgroundColor:[UIColor colorWithHexString:@"#F7F7F7"]];
        [self.selectedBtn setTitleColor:kHexColor(@"#FFA300") forState:UIControlStateNormal];

        self.photoImageView.hidden = NO;
    
    }else{
        
        [self.selectedBtn setBackgroundColor:[UIColor colorWithHexString:@"#F7F7F7"]];
        [self.selectedBtn setTitleColor:kTextColor forState:UIControlStateNormal];

        self.photoImageView.hidden = YES;
    }
    
}
- (void)setNumberModel:(AddNumberModel *)numberModel
{
    
    
    _numberModel = numberModel;
}

@end
