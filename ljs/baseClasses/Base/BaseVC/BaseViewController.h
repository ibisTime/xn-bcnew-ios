//
//  BaseViewController.h
//  BS
//
//  Created by 蔡卓越 on 16/3/31.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMMobClick/MobClick.h>
#import "CoinHeader.h"
@interface BaseViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) NSString *titleStr;

@property (nonatomic, strong) UIView *placeholderView;

@property (nonatomic, strong) UIScrollView *bgSV;

- (void)placeholderOperation;

- (void)setPlaceholderViewTitle:(NSString *)title  operationTitle:(NSString *)optitle;

- (void)removePlaceholderView; //移除
- (void)addPlaceholderView; // 添加
- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC;
/**
 登录成功后执行loginSuccess
 */
- (void)checkLogin:(void(^)(void))loginSuccess;
/**
 登录成功后执行loginSuccess
 已经登录的执行event
 */
- (void)checkLogin:(void(^)(void))loginSuccess event:(void(^)(void))event;

@end
