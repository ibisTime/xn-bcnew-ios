//
//  HomePageCircleTableView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "CircleCommentModel.h"

@interface HomePageCircleTableView : TLTableView
//
@property (nonatomic, strong) NSArray <CircleCommentModel *>*pageModels;

@end
