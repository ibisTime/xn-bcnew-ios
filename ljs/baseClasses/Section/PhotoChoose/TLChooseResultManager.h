//
//  TLChooseResultManager.h
//  CityBBS
//
//  Created by  蔡卓越 on 2017/3/21.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLPhotoChooseItem;

@interface TLChooseResultManager : NSObject

+ (instancetype)manager;

@property (nonatomic, strong) NSMutableArray <TLPhotoChooseItem *>*hasChooseItems;
@property (nonatomic, assign) NSInteger maxCount;


@end
