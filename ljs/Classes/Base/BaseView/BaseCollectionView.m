//
//  BaseCollectionView.m
//  ZhiYou
//
//  Created by 蔡卓越 on 16/1/13.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "BaseCollectionView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import <UIScrollView+TLAdd.h>

#define  adjustsContentInsets(scrollView)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
}\
_Pragma("clang diagnostic pop") \
} while (0)

@interface BaseCollectionView()

@property (nonatomic, copy) void(^refresh)();
/**
 * 上拉加载更多
 */
@property (nonatomic, copy) void(^loadMore)(void);

@end

@implementation BaseCollectionView

static NSString *placeholderViewID = @"placeholderViewID";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        [self initWithCollectionView];
    }
    return self;
}

/**
 *  初始化 collectionview
 */
- (void)initWithCollectionView {
    
    self.dataSource = self;
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = kWhiteColor;
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    //尾视图注册
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:placeholderViewID];
}

- (void)setRefreshDelegate:(id<RefreshCollectionViewDelegate>)refreshDelegate refreshHeadEnable:(BOOL)headEnable refreshFootEnable:(BOOL)footEnable autoRefresh:(BOOL)autoRefresh {
    
    self.refreshDelegate = refreshDelegate;
    
}

//刷新
- (void)addRefreshAction:(void (^)())refresh
{
    self.refresh = refresh;
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:self.refresh];
    self.mj_header = header;
}

- (void)addLoadMoreAction:(void (^)())loadMore
{
    
    self.loadMore = loadMore;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:loadMore];
    
    UIImageView *logo = [[UIImageView  alloc] initWithFrame:footer.bounds];
    logo.image = [UIImage imageNamed:@"logo_small"];
    [footer addSubview:logo];
    footer.arrowView.hidden = YES;
    self.mj_footer = footer;
    
}


- (void)beginRefreshing
{
    if (self.mj_header == nil) {
        return;
    }
    [self.mj_header beginRefreshing];
    
}

- (void)endRefreshHeader
{
    
    if (self.mj_header == nil) {
        
    }else{
        
        [self.mj_header endRefreshing];
    }
    
}

- (void)endRefreshFooter
{
    if (!self.mj_footer) {
        NSLog(@"刷新尾部组件不存在");
        return;
    }
    [self.mj_footer endRefreshing];
}

- (void)endRefreshingWithNoMoreData_tl
{
    if (self.mj_footer) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)resetNoMoreData_tl
{
    if (self.mj_footer) {
        [self.mj_footer resetNoMoreData];
    }
    
}

- (void)setHiddenFooter:(BOOL)hiddenFooter
{
    _hiddenFooter = hiddenFooter;
    if (self.mj_footer) {
        self.mj_footer.hidden = hiddenFooter;
    }else{
        NSLog(@"footer不存在");
    }
}

- (void)setHiddenHeader:(BOOL)hiddenHeader
{
    _hiddenHeader = hiddenHeader;
    if (self.mj_header) {
        
        self.mj_header.hidden = hiddenHeader;
        
    }else{
        NSLog(@"header不存在");
    }
}

- (void)reloadData_tl {
    
    [super reloadData];
    
    long sections = 1;//默认为1组
    BOOL isEmpty = YES; //判断数据是否为空
    
    //1.多少分组
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]){
        
        sections = [self.dataSource numberOfSectionsInCollectionView:self];
    }
    
    //2.每组多少Row，进儿判断数据是否为空
    for ( int i = 0; i < sections; i++) {
        long numOfRow = 0;
        
        if ([self.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]){
            
            numOfRow = [self.dataSource collectionView:self numberOfItemsInSection:i];
        }
        
        if (numOfRow > 0) { //只要有一组有数据就不为空
            isEmpty = NO;
        }
    }
    
    self.reusableView.hidden = !isEmpty;
    
}

@end

