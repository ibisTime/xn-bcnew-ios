//
//  InputTextView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/20.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
//V
#import "TLTextView.h"

@protocol InputTextViewDelegate <NSObject>

@optional

- (void)clickedSureBtnWithText:(NSString *)text;

- (void)clickedCancelBtn;

@end

@interface InputTextView : BaseView
//取消
@property (nonatomic, strong) UIButton *cancelBtn;
//发布
@property (nonatomic, strong) UIButton *sureBtn;
//评论
@property (nonatomic, strong) TLTextView *commentTV;
@property (nonatomic, assign) id <InputTextViewDelegate> delegate;

- (void)show;

@end
