//
//  PlateDetailTableView.h
//  ljs
//
//  Created by shaojianfei on 2018/6/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "PlateMineModel.h"
#import "plateDetailModel.h"
@interface PlateDetailTableView : TLTableView
@property (nonatomic, strong) NSArray <plateDetailModel *>*models;

@end
