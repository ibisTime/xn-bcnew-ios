//
//  UIScrollView+SnapShot.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/15.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "UIScrollView+SnapShot.h"

@implementation UIScrollView (SnapShot)


- (UIImage *)snapshotViewWithCapInsets:(UIEdgeInsets)capInsets {
    
    return [self snapshotViewFromRect:CGRectZero withCapInsets:capInsets];
}

- (UIImage *)snapshotViewFromRect:(CGRect)rect withCapInsets:(UIEdgeInsets)capInsets {
    
    CGSize size = self.contentSize;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了

    UIGraphicsBeginImageContextWithOptions(size, YES, 3.0);

    //保存scrollView当前的偏移量
    CGPoint savedContentOffset = self.contentOffset;
    CGRect saveFrame = self.frame;

    //将scrollView的偏移量设置为(0,0)
    self.contentOffset = CGPointZero;
    self.frame = CGRectMake(0, 0, size.width, size.height);

    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    //恢复scrollView的偏移量
    self.contentOffset = savedContentOffset;
    self.frame = saveFrame;

    UIGraphicsEndImageContext();

    return image;
    
//    //保存scrollView当前的偏移量
//    CGPoint savedContentOffset = self.contentOffset;
//    CGRect frame = self.frame;
//
//    //将scrollView的偏移量设置为(0,0)
//    self.contentOffset = CGPointZero;
//
//    //修改滚动视图的frame
//    self.frame = CGRectMake(0, 0,self.contentSize.width, self.contentSize.height);
//
//    UIGraphicsBeginImageContextWithOptions(self.contentSize, NO, [UIScreen mainScreen].scale);
//    CGContextRef currentContext = UIGraphicsGetCurrentContext();
////    CGContextTranslateCTM(currentContext, - CGRectGetMinX(rect), - CGRectGetMinY(rect));
//    [self.layer renderInContext:currentContext];
//    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext(); UIGraphicsEndImageContext();
//    UIImageView *snapshotView = [[UIImageView alloc] initWithFrame:rect];
//    snapshotView.image = [snapshotImage resizableImageWithCapInsets:capInsets];
//
//    //画好后还原frame
//    self.contentOffset = savedContentOffset;
//    self.frame = frame;
//
//    return snapshotView.image;
}

@end
