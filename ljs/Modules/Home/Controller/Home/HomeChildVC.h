//
//  HomeChildVC.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeChildVC : BaseViewController
//类型
@property (nonatomic, copy) NSString *kind;
//状态
@property (nonatomic, copy) NSString *status;
//编号
@property (nonatomic, copy) NSString *code;

@property (nonatomic) BOOL isActivity;

@property (nonatomic) BOOL isSearch;

- (void)searchRequestWith:(NSString *)search;


@end
