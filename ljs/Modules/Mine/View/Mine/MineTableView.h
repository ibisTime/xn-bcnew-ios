//
//  MineTableView.h
//  Base_iOS
//
//  Created by XI on 2017/12/14.
//  Copyright © 2017年 XI. All rights reserved.
//

#import "TLTableView.h"

#import "MineGroup.h"

@interface MineTableView : TLTableView

@property (nonatomic, strong) MineGroup *mineGroup;

@property (nonatomic,assign)CGFloat headerImgHeight;

@end
