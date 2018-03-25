//
//  InfoCommentChildVC.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, MyCommentType) {
    
    MyCommentTypeCircle = 0,    //圈子评论
    MyCommentTypeInfo,          //资讯评论
};

@interface InfoCommentChildVC : BaseViewController
//
@property (nonatomic, copy) NSString *type;
//评论类型
@property (nonatomic, assign) MyCommentType commentType;

@end
