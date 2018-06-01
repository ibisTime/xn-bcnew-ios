//
//  activeContent.h
//  ljs
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef void(^heightBlock)(CGFloat index);

#import "BaseView.h"
#import "DetailActModel.h"
@interface activeContent : BaseView
@property (nonatomic, strong) DetailActModel *detailActModel;
@property (nonatomic,copy)  heightBlock selectBlock;

@end
