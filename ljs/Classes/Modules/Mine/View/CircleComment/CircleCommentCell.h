//
//  CircleCommentCell.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "MyCommentModel.h"

@interface CircleCommentCell : BaseTableViewCell
//
@property (nonatomic, strong) MyCommentModel *commentModel;
//
@property (nonatomic, strong) UIView *articleView;

@end
