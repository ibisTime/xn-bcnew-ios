//
//  ArticleStateController.h
//  ljs
//
//  Created by shaojianfei on 2018/5/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

@interface ArticleStateController : BaseViewController
//类型
@property (nonatomic, copy) NSString *kind;
//状态
@property (nonatomic, copy) NSString *status;
//编号
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *type;

@end
