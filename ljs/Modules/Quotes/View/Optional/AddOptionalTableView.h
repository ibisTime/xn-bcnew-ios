//
//  AddOptionalTableView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "OptionalModel.h"

@interface AddOptionalTableView : TLTableView
//
@property (nonatomic, strong) NSMutableArray <OptionalModel *>*optionals;
//类型
@property (nonatomic, copy) NSString *type;

@end
