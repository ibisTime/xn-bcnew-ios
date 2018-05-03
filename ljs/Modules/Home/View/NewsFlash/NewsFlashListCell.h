//
//  NewsFlashListCell.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "NewsFlashModel.h"

@interface NewsFlashListCell : BaseTableViewCell
//分享
@property (nonatomic, strong) UIButton *shareBtn;
//
@property (nonatomic, strong) NewsFlashModel *flashModel;
//是否全部
@property (nonatomic, assign) BOOL isAll;

@end
