//
//  ForumCircleTableView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "ForumCommentModel.h"
#import "ForumDetailModel.h"

@interface ForumCircleTableView : TLTableView
//最新评论
@property (nonatomic, strong) NSArray <ForumCommentModel*> *newestComments;
//
@property (nonatomic, strong) ForumDetailModel *detailModel;
//vc是否可滚动
@property (nonatomic, assign) BOOL vcCanScroll;

@end
