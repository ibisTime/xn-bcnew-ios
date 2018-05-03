//
//  TabBarModel.h
//  ljs
//
//  Created by 蔡卓越 on 2017/7/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface TabBarModel : BaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *selectedImgUrl;
@property (nonatomic, copy) NSString *unSelectedImgUrl;
@property (nonatomic, assign) BOOL isSelected;

@end
