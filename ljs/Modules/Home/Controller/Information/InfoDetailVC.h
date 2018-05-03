//
//  InfoDetailVC.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

@interface InfoDetailVC : BaseViewController
//编号
@property (nonatomic, copy) NSString *code;
//取消收藏/收藏
@property (nonatomic, copy) void(^collectionBlock)();

@end
