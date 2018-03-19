//
//  InformationListTableView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "InformationModel.h"

@interface InformationListTableView : TLTableView
//
@property (nonatomic, strong) NSArray <InformationModel *>*infos;

@end
