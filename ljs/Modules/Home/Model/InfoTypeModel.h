//
//  InfoTypeModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface InfoTypeModel : BaseModel
//编号
@property (nonatomic, copy) NSString *code;
//名字
@property (nonatomic, copy) NSString *name;

@end
