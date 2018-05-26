//
//  MaskShowView.m
//  ljs
//
//  Created by shaojianfei on 2018/5/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MaskShowView.h"

@interface MaskShowView()

@property (nonatomic, strong) UIView  *contentView;


@end
@implementation MaskShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    
    /*创建灰色背景*/
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.alpha = 0.3;
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    
    
    /*添加手势事件,移除View*/
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissContactView:)];
//    [bgView addGestureRecognizer:tapGesture];
    
    /*创建显示View*/
    _contentView = [[UIView alloc] init];
    _contentView.frame = self.frame;
    _contentView.backgroundColor=[UIColor clearColor];
    _contentView.alpha = 0.2;

    _contentView.layer.cornerRadius = 4;
    _contentView.layer.masksToBounds = YES;
    [self addSubview:_contentView];
    /*可以继续在其中添加一些View 虾米的*/
    
}
#pragma mark - 手势点击事件,移除View


-(void)dismissContactView
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    
}

// 这里加载在了window上
-(void)showView
{
    UIWindow * window = [UIApplication sharedApplication].windows[0];
    [window addSubview:self];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end
