//
//  CircleCommentModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@class CirclePost;
@interface CircleCommentModel : BaseModel

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger pointCount;
//评论时间
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
//帖子信息
@property (nonatomic, strong) CirclePost *post;
//CellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@end

@interface CirclePost : NSObject

@property (nonatomic, copy) NSString *plateCode;

@property (nonatomic, assign) NSInteger pointCount;

@property (nonatomic, copy) NSString *plateName;

@property (nonatomic, copy) NSString *publishDatetime;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *updater;

@property (nonatomic, assign) NSInteger commentCount;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *content;

@end
