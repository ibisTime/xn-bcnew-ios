//
//  EditVC.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/20.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseViewController.h"
#import "UserEditModel.h"

typedef  NS_ENUM(NSInteger,UserEditType) {
    
    UserEditTypeNickName = 0,
    UserEditTypeEmail
    
};

@interface EditVC : BaseViewController

@property (nonatomic, strong) UserEditModel *editModel;
@property (nonatomic, copy) void (^done)();
@property (nonatomic, assign) UserEditType type;

@end
