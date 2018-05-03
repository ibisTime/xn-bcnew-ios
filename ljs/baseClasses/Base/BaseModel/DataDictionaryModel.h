//
//  DataDictionaryModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

/**
 数据字典
 */
@interface DataDictionaryModel : BaseModel
//内容
@property (nonatomic, copy) NSString *dvalue;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, copy) NSString *dkey;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *parentKey;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, copy) NSString *updater;

@end
