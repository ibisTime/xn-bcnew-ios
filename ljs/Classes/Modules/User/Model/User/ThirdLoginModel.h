//
//  ThirdLoginModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSInteger, ThirdType) {
    
    ThirdTypeQQ = 0,        //QQ
    ThirdTypeWeChat,        //微信好友
    ThirdTypeTimeLine,      //朋友圈
    ThirdTypeWeiBo,         //微博
};

@interface ThirdLoginModel : BaseModel
//名称
@property (nonatomic, copy) NSString *name;
//图片
@property (nonatomic, copy) NSString *photo;
//类型
@property (nonatomic, assign) ThirdType type;

@end
