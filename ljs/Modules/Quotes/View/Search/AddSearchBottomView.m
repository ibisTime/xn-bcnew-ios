//
//  AddSearchBottomView.m
//  ljs
//
//  Created by shaojianfei on 2018/5/29.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AddSearchBottomView.h"

@interface AddSearchBottomView()
@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UILabel *titleDet;
@property (nonatomic, strong) UILabel * readCountDet;

@end

@implementation AddSearchBottomView

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

- (void)initSubviews
{
    self.titleView = [[UIView alloc] init];
    self.titleView.backgroundColor = kClearColor;
    [self addSubview:self.titleView];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        
        make.height.equalTo(@41);
        
    }];
    
    //2
    self.titleDet = [UILabel labelWithBackgroundColor:kClearColor textColor:kBlackColor font:17];
    self.titleDet.textAlignment = NSTextAlignmentLeft;
    [self.titleView addSubview:self.titleDet];
    
    
    [self.titleDet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_top).offset(10);
        make.left.offset(15);
        make.width.offset(80);
        
    }];
    
    
    //4
    self.readCountDet = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#818181") font:14];
    [self.titleView addSubview:self.readCountDet];
    
    [self.readCountDet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_top).offset(10);
        make.left.equalTo(self.titleDet.mas_right).offset(5);
        make.width.offset(80);

    }];
    
    
}

-(void)setCurrentCount:(NSInteger )currentCount
{
    _currentCount = currentCount;
    self.titleDet.text = @"推荐栏目";
    self.readCountDet.text = [NSString stringWithFormat:@"可再选%ld个",currentCount];
}
@end