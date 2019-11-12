//
//  CurrencyBottomView.h
//  ljs
//
//  Created by zhangfuyu on 2018/5/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyKLineVC.h"
#import "PlatformModel.h"
@protocol CurrencyBottomViewDelegate <NSObject>

- (void)selectBtnisChangeWrning:(BOOL)isChage with:(UIButton *)sender;
- (void)opendAnalysisVC;
- (void)addchouse;
@end

@interface CurrencyBottomView : UIView
@property (nonatomic , weak)id <CurrencyBottomViewDelegate>delegate;

@property (nonatomic , strong) CurrencyKLineVC *kine;
@property (nonatomic , strong) UIButton *optionBtn;
@property (nonatomic, strong) PlatformModel *platform;

@end
