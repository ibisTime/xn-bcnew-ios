//
//  SearchHistoryChildVC.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchHistoryChildVC : BaseViewController

@property (nonatomic, copy) void(^historyBlock)(NSString *searchStr);
//保存搜索历史
- (void)saveSearchRecord:(NSString *)searchStr;

@end
