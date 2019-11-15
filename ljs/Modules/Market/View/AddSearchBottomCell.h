//
//  AddSearchBottomCell.h
//  ljs
//
//  Created by shaojianfei on 2018/5/30.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNumberModel.h"
#import "CurrencyTitleModel.h"
@interface AddSearchBottomCell : UICollectionViewCell
@property (nonatomic , strong) AddNumberModel *numberModel;
@property (nonatomic , copy) CurrencyTitleModel *title;

@end
