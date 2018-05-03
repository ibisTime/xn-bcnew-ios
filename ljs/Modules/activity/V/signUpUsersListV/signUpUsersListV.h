//
//  signUpUsersListV.h
//  ljs
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "signUpUsersListModel.h"
@interface signUpUsersListV : TLTableView
@property (nonatomic, strong) NSArray *approvedList;
@property (nonatomic, strong) NSArray <signUpUsersListModel *>*signUpUsersListM;



@end
