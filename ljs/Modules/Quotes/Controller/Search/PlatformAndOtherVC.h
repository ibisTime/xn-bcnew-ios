//
//  PlatformAndOtherVC.h
//  ljs
//
//  Created by zhangfuyu on 2018/5/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PlatformAndOtherVC : UIViewController
@property (nonatomic , copy)NSString *searchText;
- (void)searchRequestWith:(NSString *)search;
@end
