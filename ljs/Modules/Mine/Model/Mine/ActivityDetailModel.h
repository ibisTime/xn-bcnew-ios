//
//  ActivityDetailModel.h
//  ljs
//
//  Created by shaojianfei on 2018/5/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface ActivityDetailModel : BaseModel
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * advPic;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * longitude;
@property (nonatomic, copy) NSString * latitude;
@property (nonatomic, copy) NSString * startDatetime;
@property (nonatomic, copy) NSString * endDatetime;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * maxCount;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * contactMobile;
@property (nonatomic, copy) NSString * applyDatetime;
@property (nonatomic, copy) NSString * readCount;
@property (nonatomic, copy) NSString * pointCount;
@property (nonatomic, copy) NSString * commentCount;
@property (nonatomic, copy) NSString * collectCount;
@property (nonatomic, copy) NSString * toApproveCount;
@property (nonatomic, copy) NSString * approveCount;


@end
