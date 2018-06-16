//
//  ActivityListModel.h
//  ljs
//
//  Created by shaojianfei on 2018/5/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"
#import "ActivityDetailModel.h"
@interface ActivityListModel : BaseModel
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * actCode;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * realName;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * applyDatetime;
@property (nonatomic, copy) NSString * approver;
@property (nonatomic, copy) NSString * approveDatetime;
@property (nonatomic, copy) NSString * approveNote;
@property (nonatomic, strong) ActivityDetailModel *activity;

@property (nonatomic,copy) NSString * advPic;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * endDatetime;
@property (nonatomic,copy) NSString * startDatetime;
@property (nonatomic,copy) NSString * address;
@property (nonatomic,copy) NSString * readCount;
//
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *isEnroll;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic,copy) NSString * isTop;



@end
