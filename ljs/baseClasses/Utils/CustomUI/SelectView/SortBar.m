//
//  SortOrderBar.m
//  BS
//
//  Created by 蔡卓越 on 16/4/21.
//  Copyright © 2016年 caizhuoyue. All rights reserved.
//

#import "SortBar.h"

#import "NSString+CGSize.h"
#import <UIScrollView+TLAdd.h>

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#define btnNum (_sortNames.count > 5 ? 5: _sortNames.count)
#define widthItem (kScreenWidth/(btnNum*1.0))
#define btnFont MIN(kWidth(15.0), 15)

static const float kAnimationdDuration = 0.3;

@interface SortBar ()

@property (nonatomic, copy) SortSelectBlock sortBlock;

@property (nonatomic, strong) NSArray *sortNames;

@property (nonatomic, strong) UIView *selectLine;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, assign) CGFloat btnW;
//
@property (nonatomic, assign) CGFloat allBtnWidth;

@end

@implementation SortBar


- (instancetype)initWithFrame:(CGRect)frame sortNames:(NSArray*)sortNames sortBlock:(SortSelectBlock)sortBlock {
    if (self = [super initWithFrame:frame]) {
        
        _sortBlock = [sortBlock copy];
        
        _sortNames = [NSArray arrayWithArray:sortNames];
        
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
        [self adjustsContentInsets];
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    if (self.sortNames.count == 0) {
        
        return ;
    }
    
    [self createItems];
    
    [self changeItemTitleColorWithIndex:0];
    
    CGFloat lineW = [NSString getWidthWithString:self.sortNames[0] font:MIN(kWidth(16.0), 16)];
    CGFloat lineH = 4;
    
    CGFloat leftM = self.allBtnWidth > kScreenWidth ? 10: (widthItem - lineW)/2.0;
    
    _selectLine = [[UIView alloc] init];
    
    _selectLine.backgroundColor = kAppCustomMainColor;
    _selectLine.layer.cornerRadius = lineH/2.0;
//    _selectLine.clipsToBounds = YES;

    [self addSubview:_selectLine];
    
    [_selectLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(leftM));
        make.bottom.equalTo(@(self.frame.size.height -3));
        make.width.equalTo(@(lineW));
        make.height.equalTo(@(lineH));
    }];
}

- (void)createItems {
    
    CGFloat w = 0;
    
    self.allBtnWidth = 0;
    
    //判断是否超过屏幕宽度
    
    for (NSInteger i = 0; i < _sortNames.count; i++) {
        
        NSString *title = _sortNames[i];
        
        CGFloat widthMargin = [NSString getWidthWithString:title font:MIN(kWidth(16.0), 16)] + 20 + 10;
        
        self.allBtnWidth += widthMargin;
    }
    
    
    for (NSInteger i = 0; i < _sortNames.count; i++) {
        
        NSString *title = _sortNames[i];
        
        CGFloat widthMargin = [NSString getWidthWithString:title font:MIN(kWidth(16.0), 16)] + 20;
        
        CGFloat btnW = self.allBtnWidth > kScreenWidth ? widthMargin: widthItem;
        
        UIButton *button = [UIButton buttonWithTitle:_sortNames[i] titleColor:[UIColor textColor] backgroundColor:kWhiteColor titleFont:btnFont];
        
        [button setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
        [self addSubview:button];
        button.tag = 100 +i;
        
        [button addTarget:self action:@selector(sortBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(self.mas_height);
            make.width.mas_equalTo(btnW);
            make.left.mas_equalTo(w);
        }];
        
        w += btnW;

    }
    
    self.contentSize = CGSizeMake(w, self.frame.size.height);
    
    // 强制刷新界面
    [self layoutIfNeeded];
}

#pragma mark - Private
- (void)changeItemTitleColorWithIndex:(NSInteger)index {
    
    for (NSInteger i = 0; i < _sortNames.count; i++) {
        
        UIButton *btn = [self viewWithTag:100 + i];
        if (i == index) {
            
            [btn setTitleColor:kAppCustomMainColor forState:UIControlStateNormal];
            btn.titleLabel.font = Font(MIN(kWidth(16.0), 16));
        }
        else {
            
            [btn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
            btn.titleLabel.font = Font(MIN(kWidth(15.0), 15));
        }
    }
}


#pragma mark - Public
- (void)selectSortBarWithIndex:(NSInteger)index {
    
    _selectIndex = index;
    
    UIButton *button = [self viewWithTag:100+index];
    
    CGFloat length = button.centerX - kScreenWidth/2;
    
    [self scrollRectToVisible:CGRectMake(length, 0, self.width, self.height) animated:YES];
    
    NSString *title = _sortNames[index];
    
    CGFloat widthMargin = [NSString getWidthWithString:title font:MIN(kWidth(16.0), 16)] + 20;
    
    CGFloat leftMargin = button.left + (button.width - widthMargin)/2.0 + 10;
    
    [UIView animateWithDuration:kAnimationdDuration animations:^{
        
        [_selectLine mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(leftMargin);
            make.width.mas_equalTo(widthMargin - 20);
        }];
        
        [self changeItemTitleColorWithIndex:button.tag - 100];
        
        [self layoutIfNeeded];
    }];
    
}

- (void)changeSortBarWithNames:(NSArray *)sortNames {
    
    _sortNames = [NSArray arrayWithArray:sortNames];
    
    for (NSInteger i = 0; i < _sortNames.count; i++) {
        
        UIButton *button = [self viewWithTag:100+i];
        [button setTitle:_sortNames[i] forState:UIControlStateNormal];
    }
}

- (void)resetSortBarWithNames:(NSArray*)sortNames selectIndex:(NSInteger)index {
    
    if (index < 0 && index > sortNames.count) {
        index = 0;
    }
    
    // 1.清空原来的选项
    [self clearLastItems];
    
    // 2.创建新的选项
    _sortNames = [NSArray arrayWithArray:sortNames];
    [self createItems];
    
    // 3.更改下划线位置
    [self selectSortBarWithIndex:index];
    
    //4.改变字体
    [self changeItemTitleColorWithIndex:index];
}

- (void)clearLastItems {
    
    for (NSInteger i = 0; i < _sortNames.count; i++) {
        
        UIView *subview = [self viewWithTag:100+i];
        [subview removeFromSuperview];
        subview = nil;
    }
}

#pragma mark - Events
- (void)sortBtnOnClicked:(UIButton*)button {
    // 相同按钮则不触发事件
    if (_selectIndex == button.tag - 100) {
        return;
    }
    
    _sortBlock(button.tag - 100);
    
    [self selectSortBarWithIndex:button.tag - 100];
}

- (void)setCurruntIndex:(NSInteger)curruntIndex {
    
    _curruntIndex = curruntIndex;
    
    _sortBlock(curruntIndex);
    
    [self selectSortBarWithIndex:curruntIndex];
}

@end
