//
//  CircleCommentCell.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "CircleCommentModel.h"

@interface CircleCommentCell : BaseTableViewCell
//
@property (nonatomic, strong) CircleCommentModel *commentModel;
//
@property (nonatomic, strong) UIView *articleView;
//是否回复我的
@property (nonatomic, assign) BOOL isReplyMe;

@end
