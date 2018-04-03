//
//  MineModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BaseModel.h"

@interface MineModel : BaseModel

@property (nonatomic,copy) NSString *imgName;
@property (nonatomic,copy) NSString *text;
@property (nonatomic, copy) NSString *rightText;
@property (nonatomic, assign) BOOL isSpecial;
//是否隐藏箭头
@property (nonatomic, assign) BOOL isHiddenArrow;

@property (nonatomic,strong) void(^action)();

@end
