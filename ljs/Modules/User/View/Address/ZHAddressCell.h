//
//  ZHAddressCell.h
//  ljs
//
//  Created by  tianlei on 2016/12/29.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHReceivingAddress.h"

@interface ZHAddressCell : UITableViewCell

@property (nonatomic,strong) ZHReceivingAddress *address;
@property (nonatomic,assign) BOOL isDisplay;

@property (nonatomic,copy) void(^deleteAddr)(UITableViewCell *cell);
@property (nonatomic,copy) void(^editAddr)(UITableViewCell *cell);

@property (nonatomic,copy) void(^defaultAddr)(UITableViewCell *cell);

@end
