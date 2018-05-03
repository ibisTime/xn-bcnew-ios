//
//  MyCollectionCell.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "MyCollectionModel.h"

@interface MyCollectionCell : BaseTableViewCell
//
@property (nonatomic, strong) MyCollectionModel *collectionModel;

@end
