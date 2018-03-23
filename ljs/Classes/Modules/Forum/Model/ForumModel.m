//
//  ForumModel.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumModel.h"
NSString *const kAllPost = @"1";    //全部
NSString *const kHotPost = @"2";    //热门
NSString *const kFoucsPost = @"3";  //关注

@implementation ForumModel

- (NSString *)rankImage {
    
    NSInteger rankNum = [self.rank integerValue];
    
    switch (rankNum) {
        case 1:
        {
            _rankImage = @"金";
        }break;
        case 2:
        {
            _rankImage = @"银";
        }break;
        case 3:
        {
            _rankImage = @"铜";
        }break;
            
        default:
            break;
    }
    return _rankImage;
}

- (BOOL)isTopThree {
    
    NSInteger rankNum = [self.rank integerValue];

    return _isTopThree = rankNum <=3 ? YES: NO;
}

@end
