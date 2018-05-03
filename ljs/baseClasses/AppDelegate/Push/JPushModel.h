//
//  JPushModel.h
//  ArtInteract
//
//  Created by 蔡卓越 on 2016/10/25.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseModel.h"
#import <MJExtension/MJExtension.h>
@class Aps;

@interface JPushModel : BaseModel

@property (nonatomic, strong) Aps *aps;

@property (nonatomic, copy) NSString *openType;

@property (nonatomic, copy) NSString *flashCode;

@end

@interface Aps : NSObject

@property (nonatomic, copy) NSString *alert;

@property (nonatomic, copy) NSString *badge;

@property (nonatomic, copy) NSString *sound;

@end

