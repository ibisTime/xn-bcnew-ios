//
//  QuotesOptionalChildVC.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
//M
#import "OptionalTitleModel.h"

typedef void(^AddQuotesSuccess)();

@interface QuotesOptionalChildVC : BaseViewController
//

@property (nonatomic , strong)NSString *titleStr;
@property (nonatomic, strong) OptionalTitleModel *titleModel;
//添加成功
@property (nonatomic, copy) AddQuotesSuccess addSuccess;

@end
