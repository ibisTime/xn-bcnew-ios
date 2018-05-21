//
//  Html5Vc.h
//  ljs
//
//  Created by shaojianfei on 2018/5/19.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSUInteger, HtmlType) {
    HtmlTypeTypeAboutUs = 0,    //关于我们
    //    HTMLTypeRegProtocol,    //注册协议
    
};
@interface Html5Vc : BaseViewController
@property (nonatomic, assign) HtmlType type;

@property (nonatomic, copy) NSString *ckey;
@end
