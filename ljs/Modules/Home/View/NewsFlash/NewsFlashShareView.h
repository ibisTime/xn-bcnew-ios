//
//  NewsFlashShareView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/19.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"

typedef NS_ENUM(NSInteger, NewsFlashShareType) {
    
    NewsFlashShareTypeWeChat = 0,   //微信好友
    NewsFlashShareTypeTimeLine,     //朋友圈
    NewsFlashShareTypeQQ,           //QQ
    NewsFlashShareTypeWeiBo,        //微博
};

typedef void(^shareBlock)(NewsFlashShareType type);

@interface NewsFlashShareView : BaseView
//
@property (nonatomic, copy) shareBlock shareBlock;

@end
