//
//  MyCommentDetailCell.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "InfoCommentModel.h"

@interface MyCommentDetailCell : BaseTableViewCell
//
@property (nonatomic, strong) InfoCommentModel *commentModel;
//点赞按钮
@property (nonatomic, strong) UIButton *zanBtn;
//是否回复
@property (nonatomic, assign) BOOL isReply;

@end
