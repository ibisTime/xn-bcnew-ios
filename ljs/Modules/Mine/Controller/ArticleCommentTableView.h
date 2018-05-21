//
//  ArticleCommentTableView.h
//  ljs
//
//  Created by shaojianfei on 2018/5/19.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "ArticleModel.h"
#import "ArticleCommentModel.h"
@interface ArticleCommentTableView : TLTableView
@property (nonatomic, strong) NSMutableArray < ArticleCommentModel*>*infos;

@end
