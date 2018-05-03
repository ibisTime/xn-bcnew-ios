//
//  CustomTabBar.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarModel.h"

@class CustomTabBar;
@protocol TabBarDelegate <NSObject>


/**
 点击tabbarbutton 会先调用此方法，返回yes 正常切换，NO不进行切换
 
 @param idx
 @param tabBar
 @return 是否切换
 */
- (BOOL)didSelected:(NSInteger)idx tabBar:(CustomTabBar *)tabBar;

@end

@interface CustomTabBar : UITabBar

@property (nonatomic, weak) id<TabBarDelegate> delegate;

@property (nonatomic, copy) NSArray <TabBarModel *>*tabBarItems;
@property (nonatomic, assign) NSInteger selectedIdx;

@end
