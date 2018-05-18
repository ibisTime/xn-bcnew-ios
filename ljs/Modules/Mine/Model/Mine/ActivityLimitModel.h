//
//  ActivityLimitModel.h
//  ljs
//
//  Created by shaojianfei on 2018/5/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//
#import "ActivityListModel.h"
#import "BaseModel.h"

@interface ActivityLimitModel : BaseModel
@property (nonatomic, assign) NSInteger pageNO;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) NSMutableArray *list;




@end
