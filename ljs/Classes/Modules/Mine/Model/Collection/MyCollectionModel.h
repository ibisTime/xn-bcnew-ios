//
//  MyCollectionModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface MyCollectionModel : BaseModel
//编号
@property (nonatomic, copy) NSString *code;
//标题
@property (nonatomic, copy) NSString *title;
//作者
@property (nonatomic, copy) NSString *auther;
//CellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@end
