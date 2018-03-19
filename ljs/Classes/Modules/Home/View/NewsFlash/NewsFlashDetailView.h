//
//  NewsFlashDetailView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/19.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
//M
#import "NewsFlashModel.h"

@interface NewsFlashDetailView : UIScrollView
//
@property (nonatomic, strong) NewsFlashModel *flashModel;
//APP下载地址
@property (nonatomic, copy) NSString *url;

@end
