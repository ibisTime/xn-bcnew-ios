//
//  CircleGuideView.m
//  ZhiYou
//
//  Created by 蔡卓越 on 15/11/24.
//  Copyright © 2015年 蔡卓越. All rights reserved.
//

#import "CircleGuideView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#define kTimerInterval  2;


@interface CircleGuideView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;



@end

@implementation CircleGuideView


#pragma mark - Initialization
- (void)_createSubviews {
    
    _timeInterval = kTimerInterval;
    
    // 重置定时器
    [self resetTimer];
    
    // 移除原来的 _pageControl, _scrollView重新创建
    if (_pageControl) {
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    }
    if (_scrollView) {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
    }
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = _imageNames.count;
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPage = 0;
    [_pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventTouchUpInside];
    _pageControl.autoresizingMask = UIViewAutoresizingNone;
    [self addSubview:_pageControl];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.right.top.bottom.mas_equalTo(0);
    }];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(-30);
    }];
    
    UIImage *placeHoldler = [UIImage imageNamed:@"placeholder_icon"];
    UIImageView *lastImgView = nil;
    for (NSInteger i = 0; i < _imageNames.count + 2; i++) {
        
        UIImageView *imageView =[[UIImageView alloc] init];
        if (i == 0) {
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[_imageNames lastObject]] placeholderImage:placeHoldler];
        }
        else if (i < _imageNames.count + 1) {
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:_imageNames[i-1]] placeholderImage:placeHoldler];
        }
        else {
            [imageView sd_setImageWithURL:[NSURL URLWithString:[_imageNames firstObject]] placeholderImage:placeHoldler];
        }
        
        [_scrollView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (lastImgView == nil) {
                make.left.mas_equalTo(0);
            }
            else {
                make.left.equalTo(lastImgView.mas_right);
            }
            make.top.mas_equalTo(0);
            make.height.equalTo(self.mas_height);
            make.width.equalTo(self.mas_width);
        }];
        
        lastImgView = imageView;
    }
    
    _scrollView.contentSize = CGSizeMake(self.width * (_imageNames.count+2), 0);
    CGPoint point = CGPointMake(self.width, 0);
    _scrollView.contentOffset = point;
    [_scrollView scrollRectToVisible:CGRectMake(self.width,0,self.width,self.height) animated:NO];
    _scrollView.delegate = self;
    

    _pageControl.hidden = _imageNames.count< 2;
}


- (void)addTapGestureRecognizer {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgOnClicked:)];
    [self addGestureRecognizer:tap];
}


- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageName{
    
    if (self = [super initWithFrame:frame]) {
        
        _imageNames = imageName;
        
        [self addTapGestureRecognizer];
        
        [self _createSubviews];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self addTapGestureRecognizer];
}

- (void)dealloc {
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Setter
- (void)setImageNames:(NSArray *)imageNames {
    
    _imageNames = imageNames;
    [self _createSubviews];
}


- (void)setTimeInterval:(NSTimeInterval)timeInterval {

    _timeInterval = timeInterval;
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timeInterval]];
}

#pragma mark - Private
// 重置定时器
- (void)resetTimer {
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(timeTurnPage) userInfo:nil repeats:YES];
    self.pageCounter = 0;
    [_timer fire];
}

#pragma mark - Public
- (void)startTimer {

    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timeInterval]];

}

// 暂停定时器
- (void)stopTimer {

    // 定时器没有暂停的方法 只能设置 开启时间
    [_timer setFireDate:[NSDate distantFuture]];
}

#pragma mark - Events
- (void)imgOnClicked:(UITapGestureRecognizer*)tap {
    
    if (_imgClickBlock) {
        _imgClickBlock(_pageControl.currentPage);
    }
}

// 定时器翻页
- (void)timeTurnPage {
    
   // _pageCounter = (_pageCounter < _imageNames.count) ? _pageCounter : 0;
   // _pageControl.currentPage = _pageCounter;

    // 滑动之后再计算page, 这里计算有问题
    [_scrollView setContentOffset:CGPointMake(self.width * (_pageCounter + 1),0) animated:YES];
    
    _pageCounter++;
}

// UIPagecontrol翻页
- (void)turnPage {
    
    _pageCounter = _pageControl.currentPage;
    
    [self stopTimer];
     [UIView animateWithDuration:0.2 animations:^{
         
         [_scrollView setContentOffset:CGPointMake(self.width * (_pageCounter + 1), 0) animated:YES];
     } completion:^(BOOL finished) {
        
         [self startTimer];
     }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x <= 0) {
        scrollView.contentOffset = CGPointMake(self.frame.size.width * _imageNames.count, 0);
    }
    
    // 滚动到最后一张假图的时候 回到第一张真图
    if (scrollView.contentOffset.x >= (_imageNames.count + 1) * self.frame.size.width) {
        scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    }
    // 重新计算page
    NSInteger page = self.scrollView.contentOffset.x / self.frame.size.width - 1;
    _pageControl.currentPage = page;
    _pageCounter = page;
}

// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView  {
    
    [self stopTimer];
}

// 结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self startTimer];
}


@end
