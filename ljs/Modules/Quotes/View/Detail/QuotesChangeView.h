//
//  QuotesChangeView.h
//  bige
//
//  Created by 蔡卓越 on 2018/4/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
//M
#import "PlatformTitleModel.h"
/**
 更换交易所和币种
 */
@interface QuotesChangeView : BaseView
//
@property (nonatomic, strong) NSMutableArray <PlatformTitleModel *>*titles;
//显示
- (void)show;
//隐藏
- (void)hide;

@end
