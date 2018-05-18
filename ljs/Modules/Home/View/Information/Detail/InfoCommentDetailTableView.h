//
//  InfoCommentDetailTableView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/20.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "InfoCommentModel.h"
#import "InformationListCell.h"
@interface InfoCommentDetailTableView : TLTableView
//
@property (nonatomic, strong) InfoCommentModel *commentModel;
//最新评论
@property (nonatomic, strong) NSArray <InfoCommentModel*> *newestComments;

@end
