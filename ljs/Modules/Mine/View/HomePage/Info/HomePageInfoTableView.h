//
//  HomePageInfoTableView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "MyCommentModel.h"
#import "ArticleModel.h"
#import "ArticleCommentModel.h"
@interface HomePageInfoTableView : TLTableView
//
@property (nonatomic, strong) NSArray <MyCommentModel *>*pageModels;
@property (nonatomic, strong) NSMutableArray < ArticleCommentModel*>*infos;
@property (nonatomic, assign) BOOL IsArticle;



@end
