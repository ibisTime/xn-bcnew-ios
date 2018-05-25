//
//  PlatformAndOtherVC.h
//  ljs
//
//  Created by zhangfuyu on 2018/5/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OptionalTitleModel.h"

@interface PlatformAndOtherVC : BaseViewController
@property (nonatomic , assign)BOOL isCurrency;
@property (nonatomic , copy)NSString *searchText;
- (void)searchRequestWith:(NSString *)search;
@end
