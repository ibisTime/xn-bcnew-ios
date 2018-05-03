//
//  MyCommentModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@class ArticleInfo;

@interface MyCommentModel : BaseModel

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger pointCount;

@property (nonatomic, strong) ArticleInfo *news;

@property (nonatomic, copy) NSString *commentDatetime;

@property (nonatomic, copy) NSString *parentCode;

@property (nonatomic, copy) NSString *parentUserId;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *objectCode;
//评论人
@property (nonatomic, copy) NSString *nickname;
//被评论人
@property (nonatomic, copy) NSString *parentNickName;
//评论人头像
@property (nonatomic, copy) NSString *photo;
//被评论人头像
@property (nonatomic, copy) NSString *parentPhoto;
//是我的评论
@property (nonatomic, copy) NSString *isMyComment;

@property (nonatomic, copy) NSString *status;
//CellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@end

@interface ArticleInfo : NSObject

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, assign) NSInteger pointCount;

@property (nonatomic, copy) NSString *auther;

@property (nonatomic, copy) NSString *showDatetime;

@property (nonatomic, copy) NSString *advPic;
//
@property (nonatomic, strong) NSArray <NSString *>*pics;

@property (nonatomic, copy) NSString *type;
//title
@property (nonatomic, copy) NSString *typeName;

@property (nonatomic, copy) NSString *toCoin;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *source;

@property (nonatomic, assign) NSInteger collectCount;

@property (nonatomic, copy) NSString *updater;

@property (nonatomic, assign) NSInteger commentCount;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *content;

@end
