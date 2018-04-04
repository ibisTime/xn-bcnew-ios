//
//  InfoAllCommentListTableView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/4/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "InfoCommentModel.h"
#import "InfoDetailModel.h"

@interface InfoAllCommentListTableView : TLTableView
//最新评论
@property (nonatomic, strong) NSArray <InfoCommentModel*> *newestComments;
//热门评论
@property (nonatomic, strong) InfoDetailModel *detailModel;

@end
