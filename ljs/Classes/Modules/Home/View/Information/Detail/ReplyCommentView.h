//
//  ReplyCommentView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
//M
#import "InfoCommentModel.h"
#import "ForumCommentModel.h"

@interface ReplyCommentView : BaseView
//资讯评论
@property (nonatomic, strong) InfoCommentModel *commentModel;
//圈子评论
@property (nonatomic, strong) ForumCommentModel *forumCommentModel;

@end
