//
//  CustomTabBar.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "CustomTabBar.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "UIButton+WebCache.h"
#import "BarButton.h"

#import <UIView+Frame.h>

@interface CustomTabBar ()

@property (nonatomic, strong) UIView *falseTabBar;
@property (nonatomic, strong) NSMutableArray <BarButton *>*btns;

@end

@implementation CustomTabBar
{
    
    BarButton *_lastTabBarBtn;
}
- (void)setTabBarItems:(NSArray<TabBarModel *> *)tabBarItems {
    
    _tabBarItems = [tabBarItems copy];
    
    //
    if (_tabBarItems && (_tabBarItems.count == self.btns.count)) {
        
        [_tabBarItems enumerateObjectsUsingBlock:^(TabBarModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BarButton *barBtn = self.btns[idx];
            barBtn.titleLbl.text = obj.title;
            
            //图片
            if (barBtn.isCurrentSelected) {
                
                barBtn.iconImageView.image = [UIImage imageNamed:obj.selectedImgUrl];
            } else {
                
                barBtn.iconImageView.image = [UIImage imageNamed:obj.unSelectedImgUrl];
                
            }
            
            
        }];
        
    }
    
}

- (UIView *)falseTabBar {
    
    if (!_falseTabBar) {
        
        _falseTabBar = [[UIView alloc] initWithFrame:self.bounds];
        _falseTabBar.userInteractionEnabled = YES;
        _falseTabBar.backgroundColor = [UIColor whiteColor];
        _falseTabBar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //添加5个按钮
        
        CGFloat w  = self.width/5.0;
        self.btns = [NSMutableArray arrayWithCapacity:5];
        for (NSInteger i = 0; i < 5; i ++) {
            
            BarButton *btn = [[BarButton alloc] initWithFrame:CGRectMake(i*w, 0, w, _falseTabBar.height)];
            [_falseTabBar addSubview:btn];
            //            btn.iconImageView.image = [UIImage imageNamed:@"有料_un"];
            //            btn.titleLbl.text = @"有料";
            btn.titleLbl.textColor = [UIColor colorWithHexString:@"#484848"];

            [btn addTarget:self action:@selector(hasChoose:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 100 + i;
            [self.btns addObject:btn];
            
            if (i == 0) {
                _lastTabBarBtn = btn;

                _lastTabBarBtn.selected = YES;
                btn.isCurrentSelected = YES;
                _lastTabBarBtn.titleLbl.textColor = kAppCustomMainColor;
                
            }
        }
        
    }
    
    return _falseTabBar;
}



- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self addSubview:self.falseTabBar];
    
}

- (void)setSelectedIdx:(NSInteger)selectedIdx {
    
    _selectedIdx = selectedIdx;
    
    [self.btns enumerateObjectsUsingBlock:^(BarButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == selectedIdx) {
            
            //上一个选中改变
            _lastTabBarBtn.titleLbl.textColor = [UIColor textColor];
            _lastTabBarBtn.isCurrentSelected = NO;
            NSString *lastUrlStr = self.tabBarItems[_lastTabBarBtn.tag - 100].unSelectedImgUrl;
            _lastTabBarBtn.iconImageView.image = [UIImage imageNamed:lastUrlStr];
            
            
            //---//
            //当前选中改变
            obj.titleLbl.textColor = kAppCustomMainColor;
            obj.isCurrentSelected = YES;
            NSString *currentUrlStr = self.tabBarItems[idx].selectedImgUrl;
            obj.iconImageView.image = [UIImage imageNamed:currentUrlStr];
            
            _lastTabBarBtn = obj;
            
            //
            *stop = YES;
            
        }
    }];
    
    
    
}

//点击按钮，
- (void)hasChoose:(BarButton *)btn {
    
    if ([_lastTabBarBtn isEqual:btn]) {
        
        return;
    }
    
    //当前选中的小标
    NSInteger idx = btn.tag - 100;
    
    //--//
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelected:tabBar:)]) {
        
        if([self.delegate didSelected:idx tabBar:self]) {
            
            [self changeUIWithCurrentSelectedBtn:btn idx:idx];
            
        }
        
    } else {
        
        [self changeUIWithCurrentSelectedBtn:btn idx:idx];
        
    }
    
    
}

- (void)changeUIWithCurrentSelectedBtn:(BarButton *)btn idx:(NSInteger)idx {
    
    _lastTabBarBtn.isCurrentSelected = NO;
    btn.isCurrentSelected = YES;
    
    NSInteger lastIdx = _lastTabBarBtn.tag - 100;
    //上次选中改变图片
    NSString *unselectedStr = self.tabBarItems[lastIdx].unSelectedImgUrl ;
    
    _lastTabBarBtn.iconImageView.image = [UIImage imageNamed:unselectedStr];
    
    _lastTabBarBtn.titleLbl.textColor = [UIColor textColor];
    
    //当前选中改变图片
    NSString *selectedStr = self.tabBarItems[idx].selectedImgUrl;
    btn.iconImageView.image = [UIImage imageNamed:selectedStr];
    btn.titleLbl.textColor = kAppCustomMainColor;
    
    //--//
    btn.selected = NO;
    _lastTabBarBtn = btn;
    _lastTabBarBtn.selected = YES;
    
}

@end
