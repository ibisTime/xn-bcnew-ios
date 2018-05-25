//
//  ActivityVC.h
//  ljs
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

@interface ActivityVC : BaseViewController
@property (nonatomic , assign)BOOL isSearch;
//类型
@property (nonatomic, copy) NSString *kind;

- (void)searchRequestWith:(NSString *)search;

@end
