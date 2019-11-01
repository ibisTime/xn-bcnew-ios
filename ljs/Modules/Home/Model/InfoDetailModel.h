//
//  InfoDetailModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"
//M
#import "InformationModel.h"
#import "InfoCommentModel.h"

@interface InfoDetailModel : BaseModel

@property (nonatomic, copy) NSString *summary;
//编号
@property (nonatomic, copy) NSString *code;
//类型名字
@property (nonatomic, copy) NSString *typeName;
//标题
@property (nonatomic, copy) NSString *title;
//时间
@property (nonatomic, copy) NSString *showDatetime;
//收藏数
@property (nonatomic, assign) NSInteger collectCount;
//是否收藏(1是0否)
@property (nonatomic, copy) NSString *isCollect;
//点赞数
@property (nonatomic, assign) NSInteger pointCount;
//是否点赞
@property (nonatomic, copy) NSString *isPoint;
//评论数
@property (nonatomic, assign) NSInteger commentCount;
//缩略图
@property (nonatomic, copy) NSString *advPic;
//
@property (nonatomic, strong) NSArray <NSString *>*pics;
//作者
@property (nonatomic, copy) NSString *auther;
//来源
@property (nonatomic, copy) NSString *source;
//内容
@property (nonatomic, copy) NSString *content;
//toCoin
@property (nonatomic, copy) NSString *toCoin;
//cellHeight
@property (nonatomic, assign) CGFloat cellHeight;
//相关文章
@property (nonatomic, strong) NSArray <InformationModel *>*refNewList;
//热门评论
@property (nonatomic, strong) NSArray <InfoCommentModel *>*hotCommentList;
@property (nonatomic, copy) NSString *readCount;


@end
