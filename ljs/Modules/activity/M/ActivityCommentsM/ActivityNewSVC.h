//
//  ActivityNewSVC.h
//  ljs
//
//  Created by shaojianfei on 2018/5/16.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "InfoCommentModel.h"

@interface ActivityNewSVC : BaseViewController
//评论编号
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) InfoCommentModel *commentModel;
@end
