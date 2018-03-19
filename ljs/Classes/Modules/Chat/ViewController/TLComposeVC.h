//
//  TLComposeVC.h
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/4.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLBaseVC.h"

typedef NS_ENUM(NSInteger, ArticleStatusType) {
    
    ArticleStatusTypePublish = 0,
    ArticleStatusTypeSave,
    
};

@interface TLComposeVC : TLBaseVC

@property (nonatomic, copy) void(^composeSucces)();

//帖子发布状态
@property (nonatomic, assign) ArticleStatusType statusType;

@property (nonatomic, copy) NSString *plateName;     //从版块进入

@property (nonatomic, assign) BOOL isPlatePush;

@end
