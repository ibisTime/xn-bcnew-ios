//
//  OptionalTableView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "OptionalListModel.h"

@interface OptionalTableView : TLTableView
//
@property (nonatomic, strong) NSMutableArray <OptionalListModel *>*optionals;

@end
