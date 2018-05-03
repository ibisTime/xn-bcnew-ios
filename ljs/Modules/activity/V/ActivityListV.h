//
//  ActivityListV.h
//  ljs
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "activityModel.h"
@interface ActivityListV : TLTableView
//activities
@property (nonatomic, strong) NSArray <activityModel *>*activities;

@end
