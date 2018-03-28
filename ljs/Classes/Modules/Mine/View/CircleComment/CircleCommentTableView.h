//
//  CircleCommentTableView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "CircleCommentModel.h"

@interface CircleCommentTableView : TLTableView
//
@property (nonatomic, strong) NSArray <CircleCommentModel *>*comments;
//是否回复我的
@property (nonatomic, assign) BOOL isReplyMe;

@end
