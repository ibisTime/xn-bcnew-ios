//
//  ForumDetailModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"
//M
#import "ForumCommentModel.h"

@class ForumDetailCoin;

@interface ForumDetailModel : BaseModel
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
//位置
@property (nonatomic, copy) NSString *location;
//介绍
@property (nonatomic, copy) NSString *introduce;
//是否关注
@property (nonatomic, copy) NSString *isKeep;
//状态
@property (nonatomic, copy) NSString *status;
//币种信息
@property (nonatomic, strong) ForumDetailCoin *coin;
//
@property (nonatomic, copy) NSString *toCoin;
//热门评论
@property (nonatomic, strong) NSArray <ForumCommentModel *>*hotPostList;

@end

@interface ForumDetailCoin : NSObject

@property (nonatomic, copy) NSString *ID;
//币种符号
@property (nonatomic, copy) NSString *symbol;
//流通量
@property (nonatomic, copy) NSString *totalSupply;
//发行总量
@property (nonatomic, copy) NSString *maxSupply;
//流通市值
@property (nonatomic, copy) NSString *marketCap;
//市值排行
@property (nonatomic, copy) NSString *rank;
//英文名
@property (nonatomic, copy) NSString *ename;
//中文名
@property (nonatomic, copy) NSString *cname;
//涨跌幅度
@property (nonatomic, copy) NSString *todayChange;
//24h成交量
@property (nonatomic, copy) NSString *todayVol;
//最新价格(人民币)
@property (nonatomic, copy) NSString *lastPrice;

@property (nonatomic, copy) NSString *status;

@end
