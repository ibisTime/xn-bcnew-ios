//
//  QuotesPlatForm.h
//  ljs
//
//  Created by shaojianfei on 2018/6/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "PlatformModel.h"
#import "PlatformTitleModel.h"
typedef void(^selectPlat)(NSString *);

@interface QuotesPlatForm : BaseViewController
@property (nonatomic, assign) NSInteger currentSegmentIndex;
@property (nonatomic, strong) NSArray <PlatformModel *>*platforms;
@property (nonatomic,copy) selectPlat seleBlock;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray <PlatformTitleModel *>*platformTitleList;

@end
