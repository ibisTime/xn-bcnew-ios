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
#import "InformationModel.h"

@interface InformationDetailTableView : TLTableView
//最新评论
@property (nonatomic, strong) NSArray <InfoCommentModel*> *newestComments;
//热门评论
@property (nonatomic, strong) NSArray <InfoCommentModel*> *hotComments;
//
@property (nonatomic, strong) NSArray <InformationModel*> *infos;

@end
