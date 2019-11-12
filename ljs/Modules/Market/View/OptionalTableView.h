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
typedef void(^selectCurrent)(NSString *);

@interface OptionalTableView : TLTableView
//
@property (nonatomic, strong) NSMutableArray <OptionalListModel *>*optionals;
@property (nonatomic, copy) void (^refreshBlock)();
@property (nonatomic,copy)selectCurrent selectBlock;

@end
