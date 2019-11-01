//
//  SelectScrollView.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/24.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
//V
#import "SortBar.h"

typedef void(^SelectBlock)(NSInteger index);

@interface SelectScrollView : UIView

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) UIScrollView *scrollView;
//头部
@property (nonatomic, strong) SortBar *headView;
//设置当前索引
@property (nonatomic, assign) NSInteger currentIndex;
//当前索引
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) SelectBlock selectBlock;
@property (nonatomic, assign) BOOL IsUserList;
@property (nonatomic, assign) BOOL IsCurrency;

- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray *)itemTitles;


@end
