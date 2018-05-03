//
//  ForumCircleCell.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "ForumCommentModel.h"

@interface ForumCircleCell : BaseTableViewCell
//
@property (nonatomic, strong) ForumCommentModel *commentModel;
//点赞按钮
@property (nonatomic, strong) UIButton *zanBtn;
//点击回复
@property (nonatomic, copy) void(^forumCommentReplyBlock)(NSInteger index);
@end
