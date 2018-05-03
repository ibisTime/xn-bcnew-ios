//
//  ForumQuotesTableView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "CurrencyModel.h"
#import "PlatformModel.h"

typedef NS_ENUM(NSInteger, ForumQuotesType) {
    
    ForumQuotesTypePlatform = 0,  //平台
    ForumQuotesTypeCurrency,      //币种
};

@interface ForumQuotesTableView : TLTableView

//
@property (nonatomic, strong) NSArray <CurrencyModel *>*currencys;
//
@property (nonatomic, strong) NSArray <PlatformModel *>*platforms;
//类型
@property (nonatomic, assign) ForumQuotesType type;
//vc是否可滚动
@property (nonatomic, assign) BOOL vcCanScroll;

@end
