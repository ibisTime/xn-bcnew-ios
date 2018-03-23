//
//  NewsFlashModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"
#import <UIKit/UIKit.h>

@interface NewsFlashModel : BaseModel
//编号
@property (nonatomic, copy) NSString *code;
//时间
@property (nonatomic, copy) NSString *showDatetime;
//来源
@property (nonatomic, copy) NSString *source;
//状态
@property (nonatomic, copy) NSString *status;
//内容
@property (nonatomic, copy) NSString *content;
//CellHeight
@property (nonatomic, assign) CGFloat cellHeight;
//是否选中
@property (nonatomic, assign) BOOL isSelect;
//是否阅读(1是,0否)
@property (nonatomic, copy) NSString *isRead;
//是否显示日期
@property (nonatomic, assign) BOOL isShowDate;

@end

FOUNDATION_EXTERN  NSString *const kAllNewsFlash;    //全部快讯
FOUNDATION_EXTERN  NSString *const kHotNewsFlash;    //热门快讯

