//
//  TLEmoticonGroup.h
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/5.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLEmoticon.h"

@interface TLEmoticonGroup : TLBaseModel

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *version;
//eg: 浪小花
@property (nonatomic, copy) NSString *group_name_cn;

@property (nonatomic, copy) NSArray <TLEmoticon *>*emoticons;

//图片文件夹path
@property (nonatomic, copy) NSString *path;

@end


