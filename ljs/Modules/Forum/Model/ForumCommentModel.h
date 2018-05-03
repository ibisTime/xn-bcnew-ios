//
//  ForumCommentModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"
//M
#import "ForumCommentModel.h"

@interface ForumCommentModel : BaseModel
//原生数据
//
@property (nonatomic, copy) NSString *code;
//帖子编号
@property (nonatomic, copy) NSString *plateCode;
//
@property (nonatomic, copy) NSString *plateName;
//userId
@property (nonatomic, copy) NSString *userId;
//发布时间
@property (nonatomic, copy) NSString *publishDatetime;
//头像
@property (nonatomic, copy) NSString *photo;
//评论人
@property (nonatomic, copy) NSString *nickname;
//被评论人
@property (nonatomic, copy) NSString *parentNickName;
//内容
@property (nonatomic, copy) NSString *content;
//点赞数
@property (nonatomic, assign) NSInteger pointCount;
//是否点赞
@property (nonatomic, copy) NSString *isPoint;
//1 顶级，0非顶级
@property (nonatomic, copy) NSString *isTop;
//位置
@property (nonatomic, copy) NSString *location;
//回复列表
@property (nonatomic, strong) NSArray <ForumCommentModel *>*commentList;
//cellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@end
