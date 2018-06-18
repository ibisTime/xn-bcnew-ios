//
//  PlateMineModel.h
//  ljs
//
//  Created by shaojianfei on 2018/6/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface PlateMineModel : BaseModel

@property (nonatomic ,copy) NSString *code;
@property (nonatomic ,copy) NSString *Description;

@property (nonatomic ,copy) NSString *avgChange;
@property (nonatomic ,copy) NSString *bestChange;
@property (nonatomic ,copy) NSString *worstChange;
@property (nonatomic ,copy) NSString *bestSymbol;
@property (nonatomic ,copy) NSString *worstSymbol;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *location;
@property (nonatomic ,copy) NSString *orderNo;
@property (nonatomic ,copy) NSString *status;
@property (nonatomic ,copy) NSString *createDatetime;
@property (nonatomic ,copy) NSString *updater;
@property (nonatomic ,copy) NSString *updateDatetime;
@property (nonatomic ,copy) NSString *remark;

@property (nonatomic ,copy) NSString *upCount;
@property (nonatomic ,copy) NSString *downCount;
@property (nonatomic ,copy) NSString *totalCount;
@property (nonatomic ,strong) NSMutableArray *list;
@end
