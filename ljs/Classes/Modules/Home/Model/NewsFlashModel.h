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
//时间
@property (nonatomic, copy) NSString *time;
//标题
@property (nonatomic, copy) NSString *title;
//内容
@property (nonatomic, copy) NSString *content;
//CellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@end
