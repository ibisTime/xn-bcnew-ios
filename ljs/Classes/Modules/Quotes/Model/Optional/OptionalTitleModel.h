//
//  OptionalTitleModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface OptionalTitleModel : BaseModel
//类型(0平台 1币种)
@property (nonatomic, copy) NSString *type;
//ename(请求需要)
@property (nonatomic, copy) NSString *ename;
//sname(展示需要)
@property (nonatomic, copy) NSString *sname;

@end

FOUNDATION_EXTERN  NSString *const kOptionalTypeCurrency;    //币种
FOUNDATION_EXTERN  NSString *const kOptionalTypePlatform;    //平台


