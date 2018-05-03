//
//  InfoDetailModel.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "InfoDetailModel.h"

@implementation InfoDetailModel

+ (NSDictionary *)objectClassInArray {
    
    return @{@"refNewList" : [InformationModel class],
             @"hotCommentList" : [InfoCommentModel class]};
}

@end
