//
//  CurrencyModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface CurrencyModel : BaseModel

@property (nonatomic,copy) NSString *accountNumber;

@property (nonatomic,strong) NSNumber *amount; //总额

@property (nonatomic,copy) NSString *createDatetime;
@property (nonatomic,copy) NSString *currency;
@property (nonatomic,strong) NSNumber *frozenAmount; //冻结金额
@property (nonatomic,copy) NSString *md5;
@property (nonatomic,copy) NSString *realName;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *systemCode;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *userId;

@end

FOUNDATION_EXTERN NSString *const kJF;
