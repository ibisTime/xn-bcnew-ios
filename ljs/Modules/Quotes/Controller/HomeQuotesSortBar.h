//
//  HomeQuotesSortBar.h
//  bige
//
//  Created by 蔡卓越 on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SortSelectBlock) (NSInteger index);
typedef void (^SameSelectBlock) (NSInteger ind);

@interface HomeQuotesSortBar : UIScrollView

@property (nonatomic, assign) NSInteger curruntIndex;

/**
 * 数组元素个数必须和初始化数组元素个数相同
 */
- (void)changeSortBarWithNames:(NSArray*)sortNames;

/**
 * 重新移除原来的按钮,创建新的按钮
 * @sortNames 选项的标题
 * @index     选中第几项,默认为0
 */
- (void)resetSortBarWithNames:(NSArray*)sortNames selectIndex:(NSInteger)index;


- (void)selectSortBarWithIndex:(NSInteger)index;

- (instancetype)initWithFrame:(CGRect)frame sortNames:(NSArray*)sortNames sortBlock:(SortSelectBlock)sortBlock sameBlock:(SameSelectBlock)sameBlock ;

@end
