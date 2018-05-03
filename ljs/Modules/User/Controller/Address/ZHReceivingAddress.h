//
//  ZHReceivingAddress.h
//  ljs
//
//  Created by  蔡卓越 on 2016/12/29.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "TLBaseModel.h"

@interface ZHReceivingAddress : TLBaseModel

@property (nonatomic,strong) NSString *code;
//收货人
@property (nonatomic,strong) NSString *addressee;
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *district;

@property (nonatomic,strong) NSString *detailAddress;

@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *userId;

@property (nonatomic,copy) NSString *totalAddress;
//是否默认   0:否  1:是
@property (nonatomic, copy) NSString *isDefault;

@property (nonatomic, assign) CGFloat cellHeight;

//是否是 -- 临时选择
@property (nonatomic,assign) BOOL isSelected;

@end
