//
//  InfoCommentCell.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/20.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "InfoCommentModel.h"

//M
@interface InfoCommentCell : BaseTableViewCell
//
@property (nonatomic, strong) InfoCommentModel *commentModel;
//点赞按钮
@property (nonatomic, strong) UIButton *zanBtn;
//点击回复
@property (nonatomic, copy) void(^clickReplyBlock)(NSInteger index);
@end
