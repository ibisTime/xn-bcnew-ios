//
//  ForumInfoTableView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "InformationModel.h"

@interface ForumInfoTableView : TLTableView
//
@property (nonatomic, strong) NSArray <InformationModel *>*infos;
//vc是否可滚动
@property (nonatomic, assign) BOOL vcCanScroll;

@end
