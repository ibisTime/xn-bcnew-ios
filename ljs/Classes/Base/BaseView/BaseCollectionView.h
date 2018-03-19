//
//  BaseCollectionView.h
//  ZhiYou
//
//  Created by 蔡卓越 on 16/1/13.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>
//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"

@class BaseCollectionView;

@protocol RefreshCollectionViewDelegate <NSObject>

@optional
/**
 *  下拉刷新
 */
- (void)refreshCollectionViewPullDown:(BaseCollectionView*)refreshCollectionView;
/**
 *  上拉刷新
 */
- (void)refreshCollectionViewPullUp:(id)refreshCollectionView;
/**
 *选中Cell时
 */
- (void)refreshCollectionView:(BaseCollectionView*)refreshCollectionview didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
/* 选中cell上的button时可使用 */
- (void)refreshCollectionViewButtonClick:(BaseCollectionView *)refreshCollectionView WithButton:(UIButton *)sender SelectRowAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface BaseCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak)   id<RefreshCollectionViewDelegate> refreshDelegate;  //代理
@property (nonatomic, strong) UICollectionReusableView *reusableView;

//- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
/**
 * 添加下拉事件
 */
- (void)addRefreshAction:(void(^)(void))refresh;
/**
 * 添加上拉事件
 */
- (void)addLoadMoreAction:(void(^)(void))loadMore;

/*开始刷新,刷新只能是下拉刷新*/
- (void)beginRefreshing;

/*头部——停止刷新*/
- (void)endRefreshHeader;

/* 尾部——停止刷新 */
- (void)endRefreshFooter;

/* 上拉加载更多，提示没有更多数据*/
- (void)endRefreshingWithNoMoreData_tl;


/* 重置更多数据的状态*/
- (void)resetNoMoreData_tl;

@property (nonatomic, assign) BOOL hiddenFooter;
@property (nonatomic, assign) BOOL hiddenHeader;

@property (nonatomic,strong) UIView *placeHolderView;


//****************************数据刷新   站位图相关**********************//
/*可以检测是否有数据，没有的话显示站位图，但是有个缺点，比如说第一个Cell显示固定的东西,像搜索框*/
- (void)reloadData_tl;

/*弥补上述缺点，*/
@property (nonatomic, assign) NSInteger minDisplayRowCount;

/*scrollEnabled 有数据时是否可以滑动  scrollWasEnabled无数据是是否 可以滑动  default is yes*/
//- (void)placeholderView:(UIView*(^)())placeHolder scrollEnabled:(BOOL(^)())scrollEnabled scrollWasEnabled:(BOOL(^)())scrollWasEnabled;

@end

