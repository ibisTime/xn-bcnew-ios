//
//  UIControl+Block.h
//  BS
//
//  Created by 蔡卓越 on 16/4/6.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Block)

- (void)bk_addEventHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents;

@end
