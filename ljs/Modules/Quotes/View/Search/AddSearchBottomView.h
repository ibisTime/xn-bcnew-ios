//
//  AddSearchBottomView.h
//  ljs
//
//  Created by shaojianfei on 2018/5/29.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
#import "AddNumberModel.h"

@interface AddSearchBottomView : BaseView
@property (nonatomic, strong) AddNumberModel *numberModel;
@property (nonatomic, assign) NSInteger currentCount;

@end
