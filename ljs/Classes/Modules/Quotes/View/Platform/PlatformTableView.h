//
//  PlatformTableView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "PlatformModel.h"

typedef NS_ENUM(NSInteger, PlatformType) {
    
    PlatformTypeAll = 0,        //全部
    PlatformTypeMoney,          //资金
    PlatformTypePlatform,       //具体平台
};

@interface PlatformTableView : TLTableView
//
@property (nonatomic, strong) NSArray <PlatformModel *>*platforms;
//类型
@property (nonatomic, assign) PlatformType type;

@end
