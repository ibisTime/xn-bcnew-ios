//
//  InformationListCell2.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/19.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "InformationModel.h"

@interface InformationListCell2 : BaseTableViewCell
//
@property (nonatomic, strong) InformationModel *infoModel;
//1 资讯  2 热点
@property (nonatomic, copy)NSString *kind;
@end
