//
//  ActCommentsListCell.h
//  ljs
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ActivityCommentsM.h"
@interface ActCommentsListCell : BaseTableViewCell
@property (nonatomic, strong) ActivityCommentsM *commentModel;

//点赞按钮
@property (nonatomic, strong) UIButton *zanBtn;
//点击回复
@property (nonatomic, copy) void(^clickReplyBlock)(NSInteger index);
@end
