//
//  QuotesCommentCell.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "MyCommentModel.h"

@interface QuotesCommentCell : BaseTableViewCell
//
@property (nonatomic, strong) MyCommentModel *commentModel;
//
@property (nonatomic, strong) UIView *articleView;

@end
