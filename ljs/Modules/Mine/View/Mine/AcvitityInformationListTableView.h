//
//  AcvitityInformationListTableView.h
//  ljs
//
//  Created by shaojianfei on 2018/5/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "InformationModel.h"
#import "ActivityListModel.h"
#import "ActivityDetailModel.h"
@interface AcvitityInformationListTableView : TLTableView
@property (nonatomic, strong) NSMutableArray <ActivityListModel *>*infos;

@end
