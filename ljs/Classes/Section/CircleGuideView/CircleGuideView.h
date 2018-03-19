//
//  CircleGuideView.h
//  ZhiYou
//
//  Created by 蔡卓越 on 15/11/24.
//  Copyright © 2015年 蔡卓越. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^ImageOnClicked) (NSInteger index);


@interface CircleGuideView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) NSTimer *timer;

// 更新图片数据
@property (nonatomic, strong) NSArray  *imageNames;
// 图片点击回调
@property (nonatomic, copy) ImageOnClicked imgClickBlock;
// 轮播时间间隔
@property (nonatomic, assign) NSTimeInterval timeInterval;
// 指定初始页面
@property (nonatomic, assign) NSInteger pageCounter;

// 开启定时器滚动
- (void)startTimer;

// 停止定时器滚动
- (void)stopTimer;

- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray*)imageName;

// 翻页
- (void)timeTurnPage;



@end

