//
//  FillInRegistrationFormVC.h
//  ljs
//
//  Created by apple on 2018/5/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "UserEditModel.h"

@interface FillInRegistrationFormVC : BaseViewController
@property (nonatomic, strong) UserEditModel *editModel;
@property (nonatomic,  copy) NSString *code;
@property (nonatomic, copy) void(^signUpSucessClock)(BOOL index);


@end
