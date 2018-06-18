//
//  plateDetailModel.h
//  ljs
//
//  Created by shaojianfei on 2018/6/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"

@interface plateDetailModel : TLTableView
@property (nonatomic ,copy) NSString *symbol;

@property (nonatomic ,copy) NSString *toSymbol;

@property (nonatomic ,copy) NSString *count;

@property (nonatomic ,copy) NSString *lastPrice;

@property (nonatomic ,copy) NSString *lastCnyPrice;

@property (nonatomic ,copy) NSString *percentChange24h;

@end
