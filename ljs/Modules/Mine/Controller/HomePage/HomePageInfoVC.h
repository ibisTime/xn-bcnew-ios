//
//  HomePageInfoVC.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
/**
 个人中心(从资讯进入)
 */
@interface HomePageInfoVC : BaseViewController
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
