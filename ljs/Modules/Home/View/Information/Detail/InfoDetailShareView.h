//
//  InfoDetailShareView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
//M
#import "ThirdLoginModel.h"

typedef void(^shareBlock)(ThirdType type);

@interface InfoDetailShareView : BaseView
//
@property (nonatomic, copy) shareBlock shareBlock;
//显示
- (void)show;
//隐藏
- (void)hide;

@end
