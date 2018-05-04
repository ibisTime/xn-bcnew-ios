//
//  activityModel.h
//  ljs
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface activityModel : BaseModel
//
@property (nonatomic,copy) NSString * advPic;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * endDatetime;
@property (nonatomic,copy) NSString * startDatetime;
@property (nonatomic,copy) NSString * address;
@property (nonatomic,copy) NSString * readCount;
//
@property (nonatomic,copy) NSString * status;
@property (nonatomic, copy) NSString *code;

@end
