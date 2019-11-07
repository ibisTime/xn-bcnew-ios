//
//  FeedBookDetailsTableView.h
//  Coin
//
//  Created by 郑勤宝 on 2019/5/20.
//  Copyright © 2019 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "QuestionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FeedBookDetailsTableView : TLTableView
@property (nonatomic ,strong) QuestionModel *questionModel;
@end

NS_ASSUME_NONNULL_END
