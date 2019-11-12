//
//  CurrencyKLineVC.h
//  bige
//
//  Created by 蔡卓越 on 2018/4/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
/**
 币种二级详情
 */
typedef void(^ChooseBlock)(NSInteger type);

@interface CurrencyKLineVC : BaseViewController
//币种ID
@property (nonatomic, copy) NSString *symbolID;

@property (nonatomic, copy) ChooseBlock choose;

@end
