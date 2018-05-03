//
//  MineCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MineModel.h"

@interface MineCell : UITableViewCell

@property (nonatomic, strong) MineModel *mineModel;

@property (nonatomic, strong) UILabel *rightLabel;

@end
