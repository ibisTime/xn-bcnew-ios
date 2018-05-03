//
//  TLTypeChangeView.h
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/5.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLTypeChangeView : UIView


@property (nonatomic, copy) NSArray <NSString *>*typeNames;
@property (nonatomic, copy) void (^changeType)(NSInteger idx);

- (void)changeTypeByIdx:(NSInteger)idx;

@end
