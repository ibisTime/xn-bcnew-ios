//
//  InfoCommentModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/20.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface InfoCommentModel : BaseModel
//原生数据
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *status;
//评论时间
@property (nonatomic, copy) NSString *commentDatetime;
@property (nonatomic, copy) NSString *content;
//userId
@property (nonatomic, copy) NSString *commenter;

@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *entityCode;
//评论人
@property (nonatomic, copy) NSString *nickname;
//被评论人
@property (nonatomic, copy) NSString *parentNickName;
//点赞数
@property (nonatomic, assign) NSInteger pointCount;
//是否点赞
@property (nonatomic, copy) NSString *isPoint;
//1 顶级，0非顶级
@property (nonatomic, copy) NSString *isTop;
//回复列表
@property (nonatomic, strong) NSArray <InfoCommentModel *>*commentList;
//cellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@end
