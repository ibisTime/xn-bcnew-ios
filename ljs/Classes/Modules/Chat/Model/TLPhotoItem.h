//
//  TLPhotoItem.h
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/12.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLPhotoItem : NSObject

@property (nonatomic, assign) NSInteger idx;

//二者只能存在一种
@property (nonatomic, strong) UIImage *img;
@property (nonatomic, copy) NSString *url;

//为最后一张为添加图片按钮设置
@property (nonatomic, assign) BOOL isAdd;


@end
