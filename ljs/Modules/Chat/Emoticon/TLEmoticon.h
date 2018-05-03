//
//  TLEmoticon.h
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/5.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLEmoticon : TLBaseModel

@property (nonatomic, copy) NSString *chs;
@property (nonatomic, copy) NSString *cht;
@property (nonatomic, copy) NSString *gif;
@property (nonatomic, copy) NSString *png;
@property (nonatomic, strong) NSNumber *type;

//图片路径
@property (nonatomic, copy) NSString *directory;

@end
