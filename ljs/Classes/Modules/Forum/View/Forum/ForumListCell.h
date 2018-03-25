//
//  ForumListCell.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "ForumModel.h"

@interface ForumListCell : BaseTableViewCell
//
@property (nonatomic, strong) ForumModel *forumModel;
//关注
@property (nonatomic, strong) UIButton *followBtn;

@end
