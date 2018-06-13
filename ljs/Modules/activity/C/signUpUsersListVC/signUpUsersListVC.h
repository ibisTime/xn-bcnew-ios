//
//  signUpUsersListVC.h
//  ljs
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "signUpUsersListModel.h"
@interface signUpUsersListVC : BaseViewController
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSArray <signUpUsersListModel *>*signUpUsersListM;

@end
