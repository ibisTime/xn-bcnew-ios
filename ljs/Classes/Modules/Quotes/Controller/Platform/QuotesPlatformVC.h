//
//  QuotesPlatformVC.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
//V
#import "PlatformTableView.h"
/**
 平台
 */
@interface QuotesPlatformVC : BaseViewController
//
@property (nonatomic, assign) PlatformType type;
//类型
@property (nonatomic, copy) NSString *kind;
//平台编号
@property (nonatomic, copy) NSString *code;

@end
