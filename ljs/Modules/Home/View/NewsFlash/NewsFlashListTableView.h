//
//  NewsFlashListTableView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "NewsFlashModel.h"

@interface NewsFlashListTableView : TLTableView
//
@property (nonatomic, strong) NSArray <NewsFlashModel *>*news;
//是否全部资讯
@property (nonatomic, assign) BOOL isAll;

@end
