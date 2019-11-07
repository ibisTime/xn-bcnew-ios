//
//  CurrencyHomeVC.h
//  ljs
//
//  Created by 郑勤宝 on 2019/10/31.
//  Copyright © 2019 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CurrencyHomeVC : BaseViewController

@property (nonatomic , strong)NSString *symbol;
@property (nonatomic , strong)NSString *orderColumn;
@property (nonatomic , strong)NSString *orderDir;
@end

NS_ASSUME_NONNULL_END
