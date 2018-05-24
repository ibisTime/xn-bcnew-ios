//
//  CurrencyInfoChildVC.h
//  bige
//
//  Created by 蔡卓越 on 2018/4/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
//M
#import "PlatformModel.h"

@interface CurrencyInfoChildVC : BaseViewController
//
@property (nonatomic, strong) PlatformModel *platform;
//索引
@property (nonatomic, assign) NSInteger index;
//是否滚动
@property (nonatomic, assign) BOOL vcCanScroll;

@end
