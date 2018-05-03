//
//  TLChooseResultManager.m
//  CityBBS
//
//  Created by  蔡卓越 on 2017/3/21.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "TLChooseResultManager.h"

@implementation TLChooseResultManager

+ (instancetype)manager {

    static TLChooseResultManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[TLChooseResultManager alloc] init];
        manager.hasChooseItems = [NSMutableArray array];
        manager.maxCount = 9;
    });
    
    return manager;

}

@end
