//
//  ForumDetailVC.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, ForumEntrancetype) {
    
    ForumEntrancetypeQuotes = 0,    //从行情进入
    ForumEntrancetypeForum,         //从币吧进入
};

@interface ForumDetailVC : BaseViewController
//币吧编号
@property (nonatomic, copy) NSString *code;
//币种编号
@property (nonatomic, copy) NSString *toCoin;
//入口
@property (nonatomic, assign) ForumEntrancetype type;

@end
