//
//  CircleCommentDetailVC.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

@interface CircleCommentDetailVC : BaseViewController
//评论编号
@property (nonatomic, copy) NSString *code;
//文章编号
@property (nonatomic, copy) NSString *articleCode;
//文章title
@property (nonatomic, copy) NSString *typeName;

@end
