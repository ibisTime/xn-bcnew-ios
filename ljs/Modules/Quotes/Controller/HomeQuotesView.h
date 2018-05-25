//
//  HomeQuotesView.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
//V
#import "HomeQuotesSortBar.h"

typedef void(^SelectBlock)(NSInteger index);
typedef void(^SelectSameBlock)(NSInteger ind);


@interface HomeQuotesView : BaseView

@property (nonatomic, strong) UIScrollView *scrollView;
//头部
@property (nonatomic, strong) HomeQuotesSortBar *headView;
//设置当前索引
@property (nonatomic, assign) NSInteger currentIndex;
//当前索引
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) SelectBlock selectBlock;
@property (nonatomic, copy) SelectSameBlock selectSameBlock;


- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray *)itemTitles;

@end
