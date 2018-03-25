//
//  OptionalCell.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "OptionalListModel.h"

@interface OptionalCell : BaseTableViewCell
//
@property (nonatomic, strong) OptionalListModel *optional;

@end
