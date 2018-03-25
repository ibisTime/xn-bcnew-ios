//
//  ForumModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface ForumModel : BaseModel
//编号
@property (nonatomic, copy) NSString *code;
//吧名
@property (nonatomic, copy) NSString *name;
//关注量
@property (nonatomic, assign) NSInteger keepCount;
//发帖量
@property (nonatomic, assign) NSInteger postCount;
//更贴数
@property (nonatomic, assign) NSInteger dayCommentCount;
//排名
@property (nonatomic, copy) NSString *rank;
@property (nonatomic, copy) NSString *rankImage;
//介绍
@property (nonatomic, copy) NSString *introduce;
//是否关注
@property (nonatomic, copy) NSString *isKeep;
//是否排名前三
@property (nonatomic, assign) BOOL isTopThree;
//是否是全部
@property (nonatomic, assign) BOOL isAllPost;
//位置
@property (nonatomic, copy) NSString *location;

@end

FOUNDATION_EXTERN  NSString *const kAllPost;    //全部
FOUNDATION_EXTERN  NSString *const kHotPost;    //热门
FOUNDATION_EXTERN  NSString *const kFoucsPost;  //关注

