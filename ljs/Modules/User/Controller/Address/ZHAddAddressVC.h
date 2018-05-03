//
//  ZHAddAddressVC.h
//  ljs
//
//  Created by  蔡卓越 on 2016/12/29.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "ZHReceivingAddress.h"

typedef NS_ENUM(NSInteger, AddressType) {

    AddressTypeAdd = 0,
    AddressTypeEdit,
};

@interface ZHAddAddressVC : BaseViewController

//地址新增
@property (nonatomic,strong)  void(^addAddress)(ZHReceivingAddress *address);

//地址编辑
@property (nonatomic,strong)  void(^editSuccess)(ZHReceivingAddress *address);

@property (nonatomic,strong) ZHReceivingAddress *address;

@property (nonatomic, assign) AddressType addressType;

@end
