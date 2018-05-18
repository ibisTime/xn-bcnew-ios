//
//  ActiveCommentsListViewController.h
//  ljs
//
//  Created by shaojianfei on 2018/5/17.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "InfoCommentModel.h"

@interface ActiveCommentsListViewController : BaseViewController
//评论编号
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) InfoCommentModel *commentModel;

//@property (nonatomic, strong)  InfoCommentModel *newsModel;

@end
