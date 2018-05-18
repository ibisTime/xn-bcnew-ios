//
//  ActivityNewsCommentView.h
//  ljs
//
//  Created by shaojianfei on 2018/5/16.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "InfoCommentModel.h"
#import "InfoDetailModel.h"
@interface ActivityNewsCommentView : TLTableView
//最新评论
@property (nonatomic, strong) NSArray <InfoCommentModel*> *newestComments;
//热门评论
@property (nonatomic, strong) InfoDetailModel *detailModel;
@property (nonatomic, strong) InfoCommentModel *commentModel;


@end
