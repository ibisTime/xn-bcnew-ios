//
//  WarningCurrencyView.h
//  ljs
//
//  Created by zhangfuyu on 2018/5/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@protocol  WarningCurrencyViewDelegate <NSObject>

- (void)addWarning:(NSString *)text isRmb:(BOOL)isRMB isUp:(BOOL)isup;

@end

@interface WarningCurrencyView : BaseView
@property (nonatomic , weak)id<WarningCurrencyViewDelegate>delegate;
@end
