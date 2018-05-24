//
//  WarningableViewCell.h
//  ljs
//
//  Created by zhangfuyu on 2018/5/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlatformWarningModel.h"

@interface WarningableViewCell : UITableViewCell
@property (nonatomic , strong)PlatformWarningModel *dataModel;
@property (nonatomic , strong)UIButton *deleteBtn;
@end
