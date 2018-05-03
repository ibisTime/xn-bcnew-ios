//
//  PlatformTitleModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface PlatformTitleModel : BaseModel
//ID
@property (nonatomic, copy) NSString *ID;
//ename(请求需要)
@property (nonatomic, copy) NSString *ename;
//cname(展示需要)
@property (nonatomic, copy) NSString *cname;
//状态
@property (nonatomic, copy) NSString *status;
//排序
@property (nonatomic, copy) NSString *orderNo;

@end
