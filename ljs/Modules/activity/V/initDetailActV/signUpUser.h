//
//  signUpUser.h
//  ljs
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
#import "DetailActModel.h"
#import "signUpUsersListModel.h"
@interface signUpUser : BaseView
@property (nonatomic, strong) DetailActModel *detailActModel;
@property (nonatomic, strong) NSArray <signUpUsersListModel *>*signUpUsersListM;

@property (nonatomic, copy) NSString *code;
@end
