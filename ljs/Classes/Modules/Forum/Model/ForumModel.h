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
//排名
@property (nonatomic, copy) NSString *rank;
@property (nonatomic, copy) NSString *rankImage;
//是否关注
@property (nonatomic, assign) BOOL isFollow;
//是否排名前三
@property (nonatomic, assign) BOOL isTopThree;
//是否是全部
@property (nonatomic, assign) BOOL isAllPost;

@end

FOUNDATION_EXTERN  NSString *const kAllPost;    //全部
FOUNDATION_EXTERN  NSString *const kHotPost;    //热门
FOUNDATION_EXTERN  NSString *const kFoucsPost;  //关注

