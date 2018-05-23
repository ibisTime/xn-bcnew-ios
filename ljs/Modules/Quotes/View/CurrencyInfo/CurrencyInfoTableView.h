//
//  CurrencyInfoTableView.h
//  bige
//
//  Created by 蔡卓越 on 2018/4/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "PlatformModel.h"

@interface CurrencyInfoTableView : TLTableView
//
@property (nonatomic, strong) PlatformModel *platform;
//vc是否可滚动
@property (nonatomic, assign) BOOL vcCanScroll;

@end
