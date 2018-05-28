//
//  XNBannerView.m
//  MOOM
//
//  Created by 田磊 on 16/4/12.
//  Copyright © 2016年 田磊. All rights reserved.
//

#import "TLBannerView.h"
#import "BannerCell.h"
#import "UIColor+Extension.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#define SCROLL_TIME_INTERVAL 3.0

@interface TLBannerView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) UICollectionView *bannerCollectionView;
@property (nonatomic, strong) NSMutableArray *nameS;


@property (nonatomic, strong) UIPageControl *pageControl;

@end

static NSString * const XNBannerCellID = @"XNBannerCellID ";

@implementation TLBannerView
- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _urls = [NSMutableArray array];
        _isAuto = YES;
        
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
        fl.itemSize = frame.size;
        fl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        fl.minimumLineSpacing = 0.0;
        fl.minimumInteritemSpacing = 0.0;
        
        self.bannerCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:fl];
        self.bannerCollectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bannerCollectionView];
        self.bannerCollectionView.pagingEnabled = YES;
        self.bannerCollectionView.delegate = self;
        self.bannerCollectionView.dataSource = self;
        [self.bannerCollectionView  registerClass:[BannerCell class] forCellWithReuseIdentifier:XNBannerCellID];
        self.bannerCollectionView.showsHorizontalScrollIndicator = NO;
        [self.bannerCollectionView  setContentOffset:CGPointMake(self.frame.size.width, 0)];
        
    }
    
    return self;
    
}

//- (UIPageControl *)pageCtrl {
//
//    if (!_pageCtrl) {
//
//        CGFloat pageControlHeight = 35;
//        UIPageControl *tmpPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - pageControlHeight, self.frame.size.width, pageControlHeight)];
//        [self addSubview:tmpPageControl];
//        tmpPageControl.hidesForSinglePage = YES;
//        tmpPageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        tmpPageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#cccccc"];
//        tmpPageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#fe4332"];
//        _pageCtrl = tmpPageControl;
//
//    }
//
//    return _pageCtrl;
//
//}

- (void)setImgUrls:(NSArray *)imgUrls {
    
    _imgUrls = [imgUrls copy];
    //对图片进行处理
    
    //1.对URL进行处理
    if(imgUrls.count > 0){
        
        if (imgUrls.count > 1) {
            
            _urls = [NSMutableArray arrayWithArray:imgUrls];
            [_urls insertObject:[imgUrls lastObject] atIndex:0];
            [_urls insertObject:[imgUrls firstObject] atIndex:_urls.count];
            
        } else {
            
            _urls = [NSMutableArray arrayWithArray:imgUrls];
            
        }
        
        
        if (_isAuto) {
            
            //移除指示
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj isKindOfClass:[UIPageControl class]]) {
                    [obj removeFromSuperview];
                }
                
            }];
            
            //添加
            CGFloat pageControlHeight = 35;
            UIPageControl *tmpPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - pageControlHeight, self.frame.size.width, pageControlHeight)];
            [self addSubview:tmpPageControl];
            tmpPageControl.hidesForSinglePage = YES;
            
            tmpPageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            
            tmpPageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#cccccc"];
//            tmpPageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#fe4332"];
            tmpPageControl.currentPageIndicatorTintColor = kAppCustomMainColor;
            
            
            
            //
            if (self.urls.count - 2 >= 2) {
                
                tmpPageControl.numberOfPages = self.urls.count - 2;
                
            } else {
                
                tmpPageControl.numberOfPages = 1;
                
            }
            
            //添加指示
            [self addSubview:tmpPageControl];
            self.pageControl = tmpPageControl;
            
            
        }
        
        _currentPage = 1;
        self.pageControl.currentPage = 0;
        
        
        //销毁原来的定时器
        
        if (!self.timer) {
            
            __weak typeof(self) weakself = self;
            
            NSTimer *tmpTimer = [NSTimer timerWithTimeInterval:SCROLL_TIME_INTERVAL target:weakself selector:@selector(pageScroll) userInfo:nil repeats:YES];
            //
            [[NSRunLoop currentRunLoop] addTimer:tmpTimer forMode:NSRunLoopCommonModes];
            self.timer = tmpTimer;
            
        }
        
        
//        [self.bannerCollectionView reloadData];
        
    }
    
}
- (void)setNameArry:(NSArray *)nameArry
{
    _nameArry = nameArry;
    if (nameArry.count > 1) {
        
        _nameS = [NSMutableArray arrayWithArray:nameArry];
        [_nameS insertObject:[nameArry lastObject] atIndex:0];
        [_nameS insertObject:[nameArry firstObject] atIndex:_nameS.count];
        
    } else {
        
        _nameS = [NSMutableArray arrayWithArray:nameArry];
        
    }
    
    [self.bannerCollectionView reloadData];

}
//- (void)setIsAuto:(BOOL)isAuto
//{
//    _isAuto = isAuto;
//    if (!_isAuto) {
//
//        [self.timer invalidate];
//        self.timer = nil;
//    }
//
//}

- (void)pageScroll
{
    if (self.urls.count <= 1) {
        return;
    }
    
    _currentPage ++;
    
    [self.bannerCollectionView  setContentOffset:CGPointMake(_currentPage * self.frame.size.width, 0) animated:YES];
    
    if (_currentPage == self.urls.count - 1) {
        
        _currentPage = 0;
        
    }
    
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.bannerCollectionView .contentOffset.x < self.bannerCollectionView .frame.size.width) {
        if (self.bannerCollectionView .contentOffset.x != 0) {
            return;
        }
    }
    
    
    NSInteger index = (self.bannerCollectionView .contentOffset.x )/self.frame.size.width;
    _currentPage = index - 1;
    
    //    //不循环
    if(_urls.count <= 2) return;
    
    self.pageControl.currentPage = _currentPage;
    //最后一个
    if (index == self.urls.count - 1) {
        [self.bannerCollectionView  setContentOffset:CGPointMake(self.frame.size.width, 0) ];
        
        return;
    }
    
    //滑动到前面
    if (index == 0) {
        [self.bannerCollectionView  setContentOffset:CGPointMake(self.frame.size.width*(self.urls.count - 2), 0)];
        return;
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    XNLog(@"开始拖动");
    self.timer.fireDate = [NSDate distantFuture];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.timer.fireDate = [NSDate distantPast];
    //    XNLog(@"结束拖动");
}

#pragma  mark - collectionView 点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selected) {
        
        if (_urls.count <= 2) {
            
            self.selected(indexPath.row);
            return;
        }
        
        NSInteger idx;
        if (indexPath.row == 0) {
            
            idx = self.urls.count - 2 - 1;
            
        } else if (indexPath.row == self.urls.count - 2 + 1){
            
            idx = 0;
            
        } else {
            
            idx = indexPath.row - 1;
        }
        
        self.selected(idx);
        
    }
    
}

#pragma  mark - DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.urls.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XNBannerCellID forIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor grayColor];
    
    cell.urlString = self.urls[indexPath.row];
    cell.nameText = self.nameS[indexPath.row];
    
    return cell;
}


@end
