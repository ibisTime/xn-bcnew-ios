//
//  ArticleModel.h
//  ljs
//
//  Created by shaojianfei on 2018/5/19.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"
#import "ArticleCommentModel.h"
@interface ArticleModel : BaseModel
@property (nonatomic, copy) NSString * pageNO;
@property (nonatomic, copy) NSString * start;
@property (nonatomic, copy) NSString * pageSize;
@property (nonatomic, copy) NSString * totalCount;
@property (nonatomic, copy) NSString * totalPage;
@property (nonatomic, copy) NSMutableArray <ArticleCommentModel *>* list;

@end
