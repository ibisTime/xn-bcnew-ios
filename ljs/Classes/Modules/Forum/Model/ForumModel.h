//
//  ForumModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface ForumModel : BaseModel

//吧名
@property (nonatomic, copy) NSString *name;
//关注量
@property (nonatomic, copy) NSString *followNum;
//发帖量
@property (nonatomic, copy) NSString *postNum;
//更贴数
@property (nonatomic, copy) NSString *updateNum;
//是否关注
@property (nonatomic, assign) BOOL isFollow;

@end

FOUNDATION_EXTERN  NSString *const kAllPost;    //全部
FOUNDATION_EXTERN  NSString *const kHotPost;    //热门
FOUNDATION_EXTERN  NSString *const kFoucsPost;  //关注

