//
//  signUpUsersListModel.h
//  ljs
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface signUpUsersListModel : BaseModel
@property (nonatomic, copy) NSString * id;
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
@property (nonatomic,copy) NSArray * activitys;

@end
