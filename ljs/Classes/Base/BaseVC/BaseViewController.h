//
//  BaseViewController.h
//  BS
//
//  Created by 蔡卓越 on 16/3/31.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CoinHeader.h"

@interface BaseViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) NSString *titleStr;

@property (nonatomic, strong) UIView *placeholderView;

@property (nonatomic, strong) UIScrollView *bgSV;

- (void)placeholderOperation;

- (void)setPlaceholderViewTitle:(NSString *)title  operationTitle:(NSString *)optitle;

- (void)removePlaceholderView; //移除
- (void)addPlaceholderView; // 添加

@end
