//
//  MineTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"

#import "MineGroup.h"

@interface MineTableView : TLTableView

@property (nonatomic, strong) MineGroup *mineGroup;

@property (nonatomic,assign)CGFloat headerImgHeight;

@end
