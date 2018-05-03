//
//  InformationDetailTableView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/20.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "InfoCommentModel.h"
#import "InfoDetailModel.h"

@interface InformationDetailTableView : TLTableView
//最新评论
@property (nonatomic, strong) NSArray <InfoCommentModel*> *newestComments;
//
@property (nonatomic, strong) InfoDetailModel *detailModel;

@end
