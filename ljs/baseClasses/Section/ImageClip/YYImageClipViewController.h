//
//  YYImageClipViewController.h
//  YYImageClipViewController
//
//  Created by 杨健 on 16/7/8.
//  Copyright © 2016年 杨健. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYImageClipViewController;

@protocol YYImageClipDelegate <NSObject>

- (void)imageCropper:(YYImageClipViewController *)clipViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(YYImageClipViewController *)clipViewController;

@end

@interface YYImageClipViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, weak) id<YYImageClipDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (instancetype)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
