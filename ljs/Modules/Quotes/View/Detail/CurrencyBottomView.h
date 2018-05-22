//
//  CurrencyBottomView.h
//  ljs
//
//  Created by zhangfuyu on 2018/5/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CurrencyBottomViewDelegate <NSObject>

- (void)selectBtnisChangeWrning:(BOOL)isChage with:(UIButton *)sender;
@end

@interface CurrencyBottomView : UIView
@property (nonatomic , weak)id <CurrencyBottomViewDelegate>delegate;
@end
