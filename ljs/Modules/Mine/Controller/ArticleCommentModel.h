//
//  ArticleCommentModel.h
//  ljs
//
//  Created by shaojianfei on 2018/5/19.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface ArticleCommentModel : BaseModel
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *advPic;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *auther;

@property (nonatomic, copy) NSString *ownerId;

@property (nonatomic, copy) NSString *ownerType;

@property (nonatomic, copy) NSString *updater;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, copy) NSString *pointCount;

@property (nonatomic, copy) NSString *commentCount
;
//评论人
@property (nonatomic, copy) NSString *collectCount;

@end
