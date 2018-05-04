//
//  ActivityCommentsM.h
//  ljs
//
//  Created by apple on 2018/5/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface ActivityCommentsM : BaseModel

//回复列表
@property (nonatomic, strong) NSArray <ActivityCommentsM *>*commentList;

//cellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@end
