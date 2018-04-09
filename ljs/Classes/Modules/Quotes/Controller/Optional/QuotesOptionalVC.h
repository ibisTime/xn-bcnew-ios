//
//  QuotesOptionalVC.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^AddQuotesSuccess)();

@interface QuotesOptionalVC : BaseViewController
//添加成功
@property (nonatomic, copy) AddQuotesSuccess addSuccess;

@end
