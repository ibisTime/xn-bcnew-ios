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
@property (nonatomic, copy) NSString *nickname;
//点赞数
@property (nonatomic, assign) NSInteger zanNum;
//是否点赞
@property (nonatomic, assign) BOOL isZan;
//cellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@end
