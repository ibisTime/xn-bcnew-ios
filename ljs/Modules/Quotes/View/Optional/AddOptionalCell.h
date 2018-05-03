//
//  AddOptionalCell.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "OptionalModel.h"

@interface AddOptionalCell : BaseTableViewCell
//
@property (nonatomic, strong) OptionalModel *optional;
//类型
@property (nonatomic, copy) NSString *type;

@end
