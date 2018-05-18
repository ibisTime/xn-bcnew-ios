//
//  ActivityCommentsListV.h
//  ljs
//
//  Created by apple on 2018/5/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "ActivityCommentsM.h"
#import "InfoCommentModel.h"
@interface ActivityCommentsListV : TLTableView
@property (nonatomic, strong) NSArray <InfoCommentModel *>*newestComments;

@end
