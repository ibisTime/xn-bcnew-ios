//
//  ZHReceivingAddress.m
//  ljs
//
//  Created by  蔡卓越 on 2016/12/29.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "ZHReceivingAddress.h"

#import "NSString+Extension.h"

@implementation ZHReceivingAddress

- (NSString *)totalAddress {

    return [[[self.province add:self.city] add:self.district] add:self.detailAddress];

}
@end
