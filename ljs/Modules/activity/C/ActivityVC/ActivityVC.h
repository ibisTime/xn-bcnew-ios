//
//  ActivityVC.h
//  ljs
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

@interface ActivityVC : BaseViewController
//类型
@property (nonatomic, copy) NSString *kind;

@property (nonatomic)BOOL isSearch;

- (void)searchRequestWith:(NSString *)search;

@end
