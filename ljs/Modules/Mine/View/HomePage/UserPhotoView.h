//
//  UserPhotoView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPhotoView : UIImageView

//用户编号
@property (nonatomic, copy) NSString *userId;
//评论类型(入口是资讯还是圈子)
@property (nonatomic, copy) NSString *commentType;

@end
