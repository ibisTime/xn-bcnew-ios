//
//  HomeArticleVC.h
//  ljs
//
//  Created by shaojianfei on 2018/6/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeArticleVC : BaseViewController
//用户编号
@property (nonatomic, copy) NSString *userId;
//类型
@property (nonatomic, copy) NSString *kind;
//状态
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) BOOL IsCenter ;

//编号
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *type;
@end
