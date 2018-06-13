//
//  signUserModel.h
//  ljs
//
//  Created by shaojianfei on 2018/5/31.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface signUserModel : BaseModel
@property (nonatomic, copy) NSString * userId;
@property (nonatomic,copy) NSString * mobile;
@property (nonatomic,copy) NSString * realName;
@property (nonatomic,copy) NSString * status;
@property (nonatomic,copy) NSString * approver;
@property (nonatomic,copy) NSString * approveDatetime;
@property (nonatomic,copy) NSString * approveNote;
@property (nonatomic,copy) NSString * nickname;
@property (nonatomic,copy) NSString * actCode;
@property (nonatomic,copy) NSString * applyDatetime;
@property (nonatomic,copy) NSString * photo;
@end
