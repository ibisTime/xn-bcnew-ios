//
//  ArticleStateTableView.h
//  ljs
//
//  Created by shaojianfei on 2018/5/19.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "InformationModel.h"
#import "MyCommentModel.h"
@interface ArticleStateTableView : TLTableView
@property (nonatomic, strong) NSArray <MyCommentModel *>*infos;

@end
