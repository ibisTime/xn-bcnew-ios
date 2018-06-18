//
//  TLPlateVC.h
//  ljs
//
//  Created by shaojianfei on 2018/6/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "PlatformModel.h"
#import "PlatformTitleModel.h"
#import "PlateMineModel.h"
@interface TLPlateVC : BaseViewController
@property (nonatomic, assign) NSInteger currentSegmentIndex;
@property (nonatomic, strong) NSArray <PlateMineModel *>*Plateforms;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray <PlatformTitleModel *>*platformTitleList;
@property (nonatomic, strong) PlatformTitleModel  *platformTitleModel;
@property (nonatomic, strong) NSArray <PlateMineModel *>*bottomPlateforms;

@end
