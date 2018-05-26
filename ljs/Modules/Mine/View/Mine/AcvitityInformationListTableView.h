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
@property (nonatomic, strong) NSMutableArray *infos;
//是否是收藏活动列表
@property (nonatomic , assign)BOOL siCollection;
@end
