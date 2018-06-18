//
//  PlateMineModel.m
//  ljs
//
//  Created by shaojianfei on 2018/6/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlateMineModel.h"
#import <MJExtension.h>
@implementation PlateMineModel

- (instancetype)init{
    
    
    
    if (self=[super init]) {
        
        
        
        [PlateMineModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            
            return @{
                     
                     @"description" : @"Description"
                     
                     };
            
        }];
        
        
        
    }
    
    return self;
    
}

@end
