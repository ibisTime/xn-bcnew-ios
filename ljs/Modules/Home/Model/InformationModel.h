//
//  InformationModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface InformationModel : BaseModel
//编号
@property (nonatomic, copy) NSString *code;
//标题
@property (nonatomic, copy) NSString *title;
//时间
@property (nonatomic, copy) NSString *showDatetime;
//收藏数
@property (nonatomic, assign) NSInteger collectCount;
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
//图文详情
@property (nonatomic, copy) NSString *desc;
//toCoin
@property (nonatomic, copy) NSString *toCoin;
//cellHeight
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) NSString *isTop;


@end

