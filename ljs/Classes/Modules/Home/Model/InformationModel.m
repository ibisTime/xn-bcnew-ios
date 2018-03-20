//
//  InformationModel.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "InformationModel.h"
#import "NSString+Extension.h"

@implementation InformationModel

- (NSArray *)pics {
    
    if (!_pics) {
        
        NSArray *imgs = [self.pic componentsSeparatedByString:@"||"];
        NSMutableArray *newImgs = [NSMutableArray arrayWithCapacity:imgs.count];
        [imgs enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj convertImageUrl]) {
                
                [newImgs addObject:[obj convertImageUrl]];
            }
        }];
        
        _pics = newImgs;
    }
    
    return _pics;
}

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"desc"]) {
        return @"description";
    }
    
    return propertyName;
}

@end
