//
//  InfoCommentDetailVC.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/20.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "InfoCommentModel.h"
@interface InfoCommentDetailVC : BaseViewController
//评论编号
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) InfoCommentModel *commentModel;
//@property (nonatomic, strong)  InfoCommentModel *newsModel;


@end
