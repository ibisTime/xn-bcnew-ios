//
//  PlateDetailVC.h
//  ljs
//
//  Created by shaojianfei on 2018/6/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "plateDetailModel.h"
#import "PlateMineModel.h"
@interface PlateDetailVC : BaseViewController

@property (nonatomic , copy) NSString *code;

@property (nonatomic, strong) NSArray <plateDetailModel *>*Plateforms;
@property (nonatomic, strong) PlateMineModel *model;

@end
